from codecs import decode
from collections import defaultdict
from re import match
from abc import ABC
from abc import abstractmethod
import logging
from enum import StrEnum
from itertools import count
from _collections_abc import _check_methods
from collections.abc import Iterator
from minki_opcodes import dict_opcodes

###################################################
###################################################
#                                                 #
#                    ENUMS                        #
#                                                 #
###################################################
###################################################

MinkiRegisters: set = {
    'A', 'B'
}


class MinkiAsmIns(StrEnum):
    """
    Min-kiwords (see what I did there?) saves as keys possible commands
    and as values a brief description of what each does
    """
    MOV = "moves data"
    ADD = "adds something with regA"
    SUB = "subs something to regA"
    AND = "bitwise and"
    XOR = "bitwise xor"
    OR = "bitwise or"
    NOT = "negates bits"
    SHL = "equivalent to multiply by 2"
    SHR = "equivalent to divide by 2"
    INC = "add 1 to value"
    DEC = "sub 1 to regA"
    CMP = "subs to regA a certain value"
    JMP = "loads to pc"
    JEQ = "loads to pc if z=1"
    JNE = "loads to pc if z=0"
    JGT = "loads to pc if n=0 and z=0"
    JGE = "loads to pc if n=0"
    JLT = "loads to pc if n=1"
    JLE = "loads to pc if n=1 or z=1"
    JCR = "loads to pc if c=1"
    NOP = "do nothing"
    PUSH = "saves regX into RAM[SP] and subs 1 to SP"
    POP = "complex stuff"
    CALL = "complex stuff"
    RET = "complex stuf"

###################################################
###################################################
#                                                 #
#                 EXCEPTIONS                      #
#                                                 #
###################################################
###################################################


class MinkiException(Exception):

    def __init__(self, custom_msg: str) -> None:
        print(custom_msg)
        exit(1)


class MinkiSyntaxError(MinkiException):

    def __init__(self, _line: str, _ln: int) -> None:
        custom_msg = f"MinkiSyntaxError at line {_ln}:\n\n\t\t{_line}\n"
        super().__init__(custom_msg)


class MinkiInsError(MinkiException):

    def __init__(self, _ins: str, _line: str, _ln: int) -> None:
        custom_msg = (f"MinkiInsError at line {_ln}:\n\n\t\t{_line}"
                      f"\n'{_ins}' is not a valid Minki instruction")
        super().__init__(custom_msg)


class MinkiRegError(MinkiException):

    def __init__(self, _reg: str, _line: str, _ln: int) -> None:
        custom_msg = (f"MinkiRegError at line {_ln}:\n\n\t\t{_line}"
                      f"\n'{_reg}' is not a vaild register for Minki")
        super().__init__(custom_msg)


class MinkiNumberError(MinkiException):

    def __init__(self, _num: str, _line: str, _ln: int) -> None:
        custom_msg = (f"MinkiNumberError at line {_ln}:\n\n\t\t{_line}"
                      f"\n'{_num}' is not a valid number for Minki")
        super().__init__(custom_msg)


class MinkiLabelError(MinkiException):

    def __init__(self, _name: str, _line: str, _ln: int) -> None:
        custom_msg = (f"MinkiLabelError on line {_ln}:\n\n\t\t{_line}"
                      f"\n'{_name}' is a restricted identifier or "
                      f"label does not exists at call")
        super().__init__(custom_msg)


class MinkiDataError(MinkiException):

    def __init__(self, _label: str = None, _value: bytearray = None) -> None:
        custom_msg = (f"MinkiDataError"
                      f" '{_label if _label else _value}' can't be saved. "
                      f"Either its a used name or no name has been given.")
        super().__init__(custom_msg)

###################################################
###################################################
#                                                 #
#                    TOKENS                       #
#                                                 #
###################################################
###################################################

class MinkiTokenType(ABC):

    @abstractmethod
    def __str__(self):
        """Returns the human-readable identifier"""
        raise NotImplementedError

    @abstractmethod
    def __tokenstr__(self):
        """An extra step to verify integrity"""

    @property
    @abstractmethod
    def value(self) -> bytearray | None: ...

    @value.setter
    @abstractmethod
    def value(self, new_val: int | float) -> None: ...

    @property
    @abstractmethod
    def opstr(self) -> str: ...

    @classmethod  # deprecated in Python 3.13 ... :o
    def __subclasshook__(cls, subclass: type) -> bool:
        if cls is MinkiTokenType:
            return _check_methods(subclass, '__str__',
                                  '__tokenstr__', 'value')
        return NotImplemented


class MinkiInsToken(MinkiTokenType):

    def __init__(self, _ins: str, _line: str, _ln: int) -> None:
        __val = _ins.upper()
        if __val not in MinkiAsmIns._member_map_:
            raise MinkiInsError(_ins, _line, _ln)
        super().__init__()
        self.__name__: str = _ins

    @property
    def value(self) -> bytearray | None:
        return int(0).to_bytes(2)

    @value.setter
    def value(self, _new: str) -> None: raise Exception('what?')

    def __repr__(self) -> str:
        return self.__tokenstr__()

    def __str__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self) -> str:
        return f"Ins:{self.opstr}"

    @property
    def opstr(self) -> str: return self.__name__


class MinkiRegToken(MinkiTokenType):

    def __init__(self, _reg: str, _line: str, _ln: int) -> None:
        if _reg.upper() not in MinkiRegisters:
            raise MinkiRegError(_reg, _line, _ln)
        super().__init__()
        self.__name__: str = _reg.upper()

    @property
    def value(self) -> bytearray | None:
        return int(0).to_bytes(2)

    @value.setter
    def value(self, _new: str) -> None: raise Exception('whet?')

    def __str__(self) -> str:
        return self.__tokenstr__()

    def __repr__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self):
        return f"Reg:{self.opstr}"

    @property
    def opstr(self) -> str: return self.__name__


class MinkiNumberToken(MinkiTokenType):

    def __init__(self, _number: str, _line: str, _ln: int) -> None:
        # here I try to understand the input as a number
        # actually try, other things rely on this
        self.__val = self.get_number_from(_number, _line, _ln)
        self.__name__: str = "Lit"

    @property
    def value(self) -> bytearray:
        return self.__val

    @value.setter
    def value(self, _new: bytearray) -> None: raise Exception("bro?")

    def __str__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self):
        return f"{self.opstr}:{self.value}"

    def __repr__(self) -> str:
        return self.__tokenstr__()

    @property
    def opstr(self) -> str: return self.__name__

    def get_number_from(self, _str: str, _line: str, _ln: int) -> bytearray:
        if _str.isdigit():
            return bytearray(int(_str).to_bytes(2))
        elif _str.startswith("0x"):
            return bytearray(int(_str[2:], 16).to_bytes(2))
        elif _str.startswith("0b"):
            # 0b = 0b0
            if len(_str[2:]) > 0:
                return bytearray(int(_str[2:], 2).to_bytes(2))
            else:
                return bytearray(int(0).to_bytes(2))
        elif _str.endswith('d'):
            return bytearray(int(_str[:-1]).to_bytes(2))
        elif _str.endswith('h'):
            return bytearray(int(_str[:-1], 16).to_bytes(2))
        elif _str.endswith('b'):
            return bytearray(int(_str[:-1], 2).to_bytes(2))
        else:
            raise MinkiNumberError(_str, _line, _ln)


class MinkiDirToken(MinkiTokenType):

    def __init__(self, _dir: MinkiNumberToken | MinkiRegToken,
                 _line: str, _ln: int) -> None:
        # entrega 1 no puede fallar
        super().__init__()
        self.__val: MinkiNumberToken | MinkiRegToken = _dir

    @property
    def value(self) -> bytearray | str:
        return self.__val.value

    @value.setter
    def value(self, _new: MinkiNumberToken) -> None:
        raise Exception('WWhat?')

    def __str__(self) -> str:
        return self.__tokenstr__()

    def __repr__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self) -> str:
        return f"{self.opstr}:{self.value}"
    
    def U_indirect(self) -> bool:
        return isinstance(self.__val, MinkiRegToken)

    @property
    def opstr(self) -> str:
        if isinstance(self.__val, MinkiNumberToken):
            return "(dir)"
        elif isinstance(self.__val, MinkiRegToken):
            return f"({self.__val.opstr})"


class MinkiCodeLabel(MinkiTokenType):

    def __init__(self, name: str, _line: str, _ln: int) -> None:
        super().__init__()
        # can't be restricted
        if name in MinkiAsmIns._member_map_ or name in MinkiRegisters:
            raise MinkiLabelError(name, _line, _ln)
        self.__name__ = name
        self._hindex: str = '0'
        self.updated: bool = False

    def __str__(self) -> str:
        return self.__tokenstr__()

    def __repr__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self) -> str:
        return f"CodeLabel: {self.__name__}"

    @property
    def value(self) -> str:
        return self._hindex

    @value.setter
    def value(self, _new: str) -> None:
        self._hindex = _new

    @property
    def opstr(self) -> str:
        return "ins"


class MinkiLabelPlaceholder(MinkiTokenType):
    """
    Como su nombre sugiere, se trata de un placeholder que espera ser
    transformado en `supposed`.
    """

    def __init__(
            self,
            name: str,
            supposed: MinkiNumberToken | MinkiDirToken,
            _line: str,
            _ln: int) -> None:
        super().__init__()
        if name in MinkiAsmIns._member_map_ or name in MinkiRegisters:
            raise MinkiLabelError(name, _line, _ln)
        self.__name__ = name
        self.supposed = supposed

    def __str__(self):
        return self.__tokenstr__()

    def __repr__(self) -> str:
        return self.__tokenstr__()

    def __tokenstr__(self) -> str:
        return f"LabelPlaceholder:{self.__name__} as {self.supposed}"

    @property
    def value(self) -> str:
        return self.__name__

    @property
    def opstr(self) -> str:
        return "LABEL"

###################################################
###################################################
#                                                 #
#                    COMPONENTS                   #
#                                                 #
###################################################
###################################################


class MinkiemblerBuffer:
    """
    Simple buffer that reads and writes to `content`
    """

    def __init__(self) -> None: self.__content: str = str()
    def clear(self) -> bool: del self.content
    def add(self, element: str) -> None: self.content += element
    def _get_content(self) -> str: return self.__content
    def _set_content(self, _add: str) -> None: self.__content = str(_add)
    def _del_content(self) -> None: self.__content = str()
    def __bool__(self) -> bool: return len(self.content) > 0
    content: property = property(_get_content, _set_content, _del_content)


class MinkiData:
    """
    Representation of the data in labels
    """

    def __init__(self) -> None:
        logging.debug(f"[MINKIDATA] Initialized data handler with default"
                      f" values to 0")
        self._data: list[list[str], list[list[bytearray], bytearray]] = list(
            (list(), list()))
        self._last_name: str = None
        self._minRAM: int = 0
        self._minINS: int = 0
        self.ram_addrs = defaultdict()
        self.label_addrs = defaultdict()

    def add(self, value: bytearray | str, name: str = None) -> None:
        """
        Adds the value to the database, if name is not given assumes
        its part of an array started at the last element with name given.
        If no item has been given a name yet raises exception
        """
        if not self._last_name and not name:
            raise MinkiDataError(_value=value)
        if name and name in self._data[0]:
            raise MinkiDataError(_label=name)
        if name:
            self._data[0].append(name)
            self._data[1].append(value)
            self._last_name = name
            self.ram_addrs[name] = self._minRAM.to_bytes(2)
            self._minRAM += 1
            logging.debug(f"[MINKIDATA] Loading {value}, under name "
                          f"\"{name}\"")
        else:
            if isinstance(self._data[1][-1], list):
                self._data[1][-1].append(value)
            else:
                new_array_forming = list((self._data[1][-1], value))
                self._data[1][-1] = new_array_forming
            self._minRAM += 1
            logging.debug(f"[MINKIDATA] Loading tail of \"{self._last_name}\""
                          f" and adding {value}")

    def _generate_for_lit(self, Lit: bytearray,
                          RAM_index: int) -> tuple[bytearray, bytearray]:
        """
        Creates the instructions needed to load Lit into RAM_index
        """
        o1_opcode: str = dict_opcodes.get("MOV A, Lit")
        o1_lit: str = ''.join(f'{byte:08b}' for byte in Lit)
        o1_str: str = o1_lit + o1_opcode
        o1_int: int = int(o1_str, 2)
        o1_ins: bytearray = o1_int.to_bytes(5)

        o2_opcode: str = dict_opcodes.get("MOV (dir), A")
        o2_lit: str = format(RAM_index, "016b")
        o2_str: str = o2_lit + o2_opcode
        o2_int: int = int(o2_str, 2)
        o2_ins: bytearray = o2_int.to_bytes(5)
        logging.debug(
            f"[MINKIDATA] Created loading of {Lit} into {RAM_index}\n"
            f"\tPayload as:\n"
            f"\t\t{o1_lit} + {o1_opcode}\n"
            f"\t\t{o2_lit} + {o2_opcode}\n")
        return o1_ins, o2_ins

    def dump_data(self) -> tuple[bytearray, ...]:
        """
        Dumps data into a set of instructions that loads the RAM with
        all variables in ascending order
        """
        logging.debug(f"[MINKIDATA] Starting dump for DATA")
        data_payload: list[bytearray] = list()
        cindex: int = 0
        ramindex: Iterator = count()
        while cindex < len(self._data[0]):
            if isinstance(self._data[1][cindex], bytearray):
                # directo
                data_payload.extend(self._generate_for_lit(
                    self._data[1][cindex], next(ramindex)))
            elif isinstance(self._data[1][cindex], list):
                for value in self._data[1][cindex]:
                    data_payload.extend(self._generate_for_lit(
                        value, next(ramindex)))
            cindex += 1
        self._minINS = 2 * (self._minRAM)
        return data_payload


###################################################
###################################################
#                                                 #
#                    UTILS                        #
#                                                 #
###################################################
###################################################

def tokenize_data_line(
        _line: str, _ln: int
) -> tuple[str, MinkiNumberToken] | tuple[MinkiNumberToken]:
    _line = _line.strip()
    if len(_line) == 0:
        return tuple()
    logging.debug(f"[DATA TOKENIZER] Starting tokenization of line\n\t{_line}")
    tokenized: list = list()
    buffer: MinkiemblerBuffer = MinkiemblerBuffer()
    rindex: Iterator = count()
    found: int = 0
    search = True
    while (current := next(rindex)) < len(_line) and found < 2 and search:
        # If comment we ignore
        if _line[current] == '/':
            try:
                if _line[current + 1] != '/':
                    raise MinkiSyntaxError(_line, _ln)
            except IndexError:
                raise MinkiSyntaxError(_line, _ln)
            search = False

        elif _line[current] == ';':
            search = False

        # if space we ignore
        elif _line[current].isspace():
            pass

        elif _line[current].isalnum() or _line[current].isidentifier():
            buffer.add(_line[current])
            sub_current = current + 1
            while (len(_line) > sub_current and
                   ((buffer.content + _line[sub_current]).isidentifier()
                   or (buffer.content + _line[sub_current]).isalnum())):
                buffer.add(_line[sub_current])
                sub_current += 1
            tokenized.append(buffer.content)
            buffer.clear()
            for _ in range(sub_current - current - 1): next(rindex)
            found += 1

        # Manejamos los casos de string
        elif _line[current] == '"' or _line[current] == '\'':
            # Obtenemos el texto
            closing = _line[current]
            escape = False
            sub_current = current + 1
            while (((_line[sub_current] != closing)
                   or (_line[sub_current] == closing and escape))
                   and (len(_line) > sub_current)):
                if _line[sub_current] == closing and escape:
                    buffer.add(_line[sub_current])
                    escape = False
                elif _line[sub_current] == '\\' and not escape:
                    escape = True
                elif _line[sub_current] == '\\' and escape:
                    buffer.add('\\')
                    escape = False
                else:
                    buffer.add(_line[sub_current])
                sub_current += 1
            if not len(_line) > sub_current:
                raise MinkiSyntaxError(_line, _ln)
            tokenized.append(list([character for character in buffer.content]))
            buffer.clear()
            for _ in range(sub_current - current): next(rindex)
            found += 1

    logging.debug(f"[DATA TOKENIZER] Found tokens: {tokenized}")
    match len(tokenized):
        case 1:
            if isinstance(tokenized[0], list):
                retorno = list()
                for element in tokenized[0]:
                    retorno.append(MinkiNumberToken(
                        str(ord(element)), _line, _ln))
                return [retorno]
            return [MinkiNumberToken(tokenized[0], _line, _ln)]
        case 2:
            if isinstance(tokenized[1], list):
                retorno = list()
                for element in tokenized[1]:
                    retorno.append(MinkiNumberToken(
                        str(ord(element)), _line, _ln))
                return [tokenized[0], retorno]
            return [tokenized[0], MinkiNumberToken(tokenized[1], _line, _ln)]
        case _:
            return tuple(list())


def find_code_labels(code_lines: tuple[str, ...]) -> dict:
    labels: dict = defaultdict()
    for line in code_lines:
        coincidence = match(r"^\s*([a-zA-Z_0-9]+)\s*:", line)
        if coincidence:
            label = coincidence.group(1)
            labels[label] = None
    return labels


def peek_arg(line: str, index: Iterator,
         ln: int, data: MinkiData, accept_comma: bool):
    buffer = MinkiemblerBuffer()
    search = True
    target = None
    comma_found = False
    while search and (current := next(index)) < len(line):

        # Whitespace
        if line[current].isspace(): continue

        # Comment
        elif line[current] == '/':
            if (not len(line) > current + 1) or line[current + 1] != '/':
                raise MinkiSyntaxError(line, ln)
            while current < len(line):
                current = next(index)
            search = False
        elif line[current] == ';':
            while current < len(line):
                current = next(index)
            search = False

        # Caso acceder a la RAM, uso de ()
        elif line[current] == '(':

            # Obtenemos todo lo que está encerrado
            sub_current = current + 1
            while (len(line) > sub_current and line[sub_current] != ')'):
                buffer.add(line[sub_current])
                sub_current += 1
            if not len(line) > sub_current:
                logging.error(f"Missing ')' at\n\t{line}")
                raise MinkiSyntaxError(line, ln)
            
            # Verificamos que sea algo válido
            buffer.content = buffer.content.strip()
            if not (buffer.content.isidentifier() 
                    or buffer.content.isalnum()):
                raise MinkiSyntaxError(line, ln)
            
            # Ahora si comienzan las verificaciones de lo que es
            if len(buffer.content) == 1 and buffer.content in MinkiRegisters:
                dir_value = MinkiRegToken(buffer.content, line, ln)
                token = MinkiDirToken(dir_value, line, ln)
            elif buffer.content in data.label_addrs:
                token = MinkiLabelPlaceholder(
                    buffer.content, MinkiDirToken, line, ln)
            elif buffer.content in data._data[0]:
                extra_step = str(int.from_bytes(
                    data.ram_addrs.get(buffer.content)))
                dir_value = MinkiNumberToken(extra_step, line, ln)                
                token = MinkiDirToken(dir_value, line, ln)
            else:
                dir_value = MinkiNumberToken(buffer.content, line, ln)
                token = MinkiDirToken(dir_value, line, ln)

            # Finalizamos guardando el token y ajustando el índice
            target = token
            buffer.clear()
            for _ in range(sub_current - current): next(index)
            search = False

        # Caso valor directo
        elif line[current].isalnum() or line[current].isidentifier():

            # Obtenemos el identificador
            buffer.add(line[current])
            sub_current = current + 1
            while (len(line) > sub_current
                   and ((buffer.content + line[sub_current]).isidentifier()
                        or (buffer.content + line[sub_current]).isalnum())):
                buffer.add(line[sub_current])
                sub_current += 1

            # Identificamos qué es
            if buffer.content in MinkiRegisters:
                token = MinkiRegToken(buffer.content, line, ln)
            elif buffer.content in data.label_addrs:
                token = MinkiLabelPlaceholder(
                    buffer.content, MinkiNumberToken, line, ln)
            elif buffer.content in data._data[0]:
                # si es el nombre propiamente tal, es la dirección
                extra_step = str(int.from_bytes(
                        data.ram_addrs.get(buffer.content)))
                token = MinkiNumberToken(extra_step, line, ln)
            else:
                token = MinkiNumberToken(buffer.content, line, ln)

            # Finalizamos guardando el token y ajustando el índice
            target = token
            buffer.clear()
            for _ in range(sub_current - current - 1): next(index)
            search = False

        # Podría ser una comma si es que estamos buscando después del primer
        # argumento
        elif line[current] == ',' and not accept_comma:
            logging.error("Unexpected comma ','")
            raise MinkiSyntaxError(line, ln)
        elif line[current] == ',' and not comma_found and accept_comma:
            comma_found = True
        elif line[current] == ',' and comma_found:
            logging.error("More than one ',' found")
            raise MinkiSyntaxError(line, ln)

        # Otro caso se trata de caracter no válido
        else:
            logging.error(f"Invalid char {line[current]}")
            raise MinkiSyntaxError(line, ln)
    return target

def tokenize_ins_line(
        _line: str, _ln: int, data: MinkiData
        ) -> tuple[MinkiTokenType, ...] | MinkiCodeLabel:
    _line = _line.strip()
    logging.debug(f"[CODE TOKENIZER] Working on line \n\t\"{_line}\"")
    if len(_line) == 0: return list()
    tokenized: list = list()
    rindex: Iterator = count()
    buffer: MinkiemblerBuffer = MinkiemblerBuffer()

    # Get ins
    search_ins: bool = True
    while search_ins and (current := next(rindex)) < len(_line):

        # If comment we ignore
        if _line[current] == '/':
            try:
                if _line[current + 1] != '/':
                    raise MinkiSyntaxError(_line, _ln)
            except IndexError:
                raise MinkiSyntaxError(_line, _ln)
            return tuple(tokenized)

        elif _line[current] == ';':
            return tuple(tokenized)

        # if space we ignore
        elif _line[current].isspace():
            pass

        # now we receive labels
        elif _line[current].isidentifier():
            buffer.add(_line[current])
            sub_current = current + 1
            while (len(_line) > sub_current
                   and (buffer.content + _line[sub_current]).isidentifier()):
                buffer.add(_line[sub_current])
                sub_current += 1
            while (len(_line) > sub_current and _line[sub_current].isspace()):
                sub_current += 1
            if len(_line) > sub_current and _line[sub_current] == ':':
                new_label = MinkiCodeLabel(buffer.content, _line, _ln)
                return new_label
            # if no ":" then buffer should be an ins
            search_ins = False

    buffer.content = buffer.content.upper()
    if buffer.content not in MinkiAsmIns._member_map_:
        raise MinkiSyntaxError(_line, _ln)
    tokenized.append(MinkiInsToken(buffer.content, _line, _ln))
    buffer.clear()
    for _ in range(sub_current - current - 1):
        next(rindex)

    # Get next argument
    arg_1 = peek_arg(_line, rindex, _ln, data, False)
    if arg_1: tokenized.append(arg_1)

    # Get next argument
    arg_2 = peek_arg(_line, rindex, _ln, data, True)
    if arg_2: tokenized.append(arg_2)

    return tokenized