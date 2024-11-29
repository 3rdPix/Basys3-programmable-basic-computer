from minki_collections import MinkiDirToken
from minki_collections import MinkiSyntaxError
from collections import defaultdict
from minki_collections import MinkiData
from re import match
import logging
from minki_collections import tokenize_data_line
from minki_collections import find_code_labels
from minki_collections import MinkiTokenType
from minki_collections import tokenize_ins_line
from minki_collections import tokenize_ins_line
from minki_collections import MinkiCodeLabel
from minki_collections import MinkiLabelPlaceholder
from minki_opcodes import dict_opcodes
from minki_collections import MinkiNumberToken


class Minki:

    def __init__(self) -> None:
        logging.debug(f"[MINKI] Starting system...")
        self.instructions: bytearray = bytearray()
        self.line_count: int = 0
        self.data = MinkiData()
        self.code_labels: dict = defaultdict()

    def sectionize(self, lines: tuple[str, ...]
                   ) -> tuple[bool, tuple[int, int], bool, tuple[int, int]]:
        """
        Receives lines of file, identifies and separates
        data section and code section
        """
        data_start = -1
        data_end = -1
        code_start = -1
        code_end = -1
        hindex: int = 0
        search_sections: bool = True
        while hindex < len(lines) and search_sections:
            if match(r"^\s*CODE:\s*", lines[hindex]):
                if code_start != -1: raise MinkiSyntaxError(lines[hindex], hindex)
                code_start = hindex
            elif match(r"^\s*DATA:\s*", lines[hindex]):
                if data_start != -1: raise MinkiSyntaxError(lines[hindex], hindex)
                data_start = hindex
            hindex += 1
        if data_start < code_start:
            data_end = code_start - 1
            code_end = len(lines) - 1
        elif data_start > code_start:
            code_end = data_start - 1
            data_end = len(lines) - 1
        there_is_data: bool = data_start != -1
        there_is_code: bool = code_start != -1
        self.sections: tuple = (there_is_code, (code_start, code_end),
                there_is_data, (data_start, data_end))
        logging.debug(
            f"[MINKI] Sectionized DATA between [{data_start}:{data_end}] "
            f"and CODE between [{code_start}:{code_end}]")
        return self.sections

    def build_data(self, data_lines: tuple[str, ...]) -> None:
        logging.debug(f"[MINKI] Starting build_data")
        hindex: int = 0
        while hindex < len(data_lines):
            tokens = tokenize_data_line(data_lines[hindex], hindex)
            if len(tokens) == 1:
                data = tokens[0]
                if isinstance(data, MinkiNumberToken):
                    self.data.add(data.value)
                elif isinstance(data, list):
                    for number in data:
                        self.data.add(number.value)
            elif len(tokens) == 2:
                name, data = tokens
                if isinstance(data, MinkiNumberToken):
                    self.data.add(data.value, name)
                elif isinstance(data, list):
                    self.data.add(data[0].value, name)
                    string_index = 1
                    while string_index < len(data):
                        self.data.add(data[string_index].value)
                        string_index += 1
            hindex += 1
        data_ins = self.data.dump_data()
        for element in data_ins:
            self.instructions.extend(element)
        self.line_count = self.data._minINS

    def parse_code(self, code_lines: tuple[str, ...], starts_at: int) -> None:
        logging.debug(f"[MINKI] Starting parse_code")
        data_offset = self.data._minINS
        # Encontramos los nombres de los labels, aun no sabemos cuál es su valor
        # de posición en el conjunto de instrucciones
        self.data.label_addrs = find_code_labels(code_lines)

        debug_msg = "[MINKI] Current code labels:\n\t"
        for key, value in zip(self.data.label_addrs.keys(), self.data.label_addrs.values()):
            debug_msg += str(key) + ":" + str(value) + "\n\t"
        logging.debug(debug_msg)

        # Como no podemos obtener los valores de los labels de inmediato
        # guardamos los tokens en una lista para actualizar los valores
        # mas tarde
        code_of_tokens: list[list[MinkiTokenType]] = list()

        # A cada línea necesitamos obtenerle sus tokens
        # Esta es la primera pasada por lo que no hacemos más que guardar
        first_hindex: int = 0
        ins_index: int = 0
        while first_hindex < len(code_lines):
            tokenized = tokenize_ins_line(code_lines[first_hindex], first_hindex, self.data)
            debugging_type = [type(element) for element in tokenized] if not isinstance(tokenized, MinkiCodeLabel) else type(MinkiCodeLabel)
            logging.debug(f"[MINKI] Found tokens: {tokenized}"
                          f"\n\t\t\twhich is {debugging_type}")
            # Se trata de un label
            if isinstance(tokenized, MinkiCodeLabel):
                self.data.label_addrs[tokenized.__name__] = str(ins_index + data_offset)
                first_hindex += 1
                continue

            # Está vacío
            if len(tokenized) == 0:
                first_hindex += 1
                continue

            # Caso instrucciones válidas
            code_of_tokens.append(tokenized)
            first_hindex += 1
            if tokenized[0].opstr in ["POP", "RET"]:
                ins_index += 2
            else:
                ins_index += 1
        
        debug_msg = "[MINKI] First layer of tokens:\n\t"
        for line in code_of_tokens:
            debug_msg += line.__str__() + "\n\t"
        logging.debug(debug_msg)
        
        # Todos los tokens que son MinkiLabelPlaceholder necesitamos
        # actualizarlos con el valor correspondiente del MinkiCodeLabel
        # guardado en el diccionario de direcciones
        code_of_tokens = list(map(list, code_of_tokens))
        token_hindex: int = 0
        token_cindex: int = 0
        while token_hindex < len(code_of_tokens):
            token_cindex = 0
            while token_cindex < len(code_of_tokens[token_hindex]):
                current_token = code_of_tokens[token_hindex][token_cindex]
                if isinstance(current_token, MinkiLabelPlaceholder):
                    code_of_tokens[token_hindex][token_cindex] = \
                        current_token.supposed(
                            self.data.label_addrs.get(current_token.value),
                            str(current_token), token_hindex)
                token_cindex += 1
            token_hindex += 1
        
        debug_msg = "[MINKI] Second layer of tokens:\n\t"
        for line in code_of_tokens:
            debug_msg += line.__str__() + "\n\t"
        logging.debug(debug_msg)

        # Ahora si transformamos a binario
        binary_hindex: int = 0
        while binary_hindex < len(code_of_tokens):
            line = code_of_tokens[binary_hindex]
            logging.debug(f"[MINKI] Binarizing {line} -> {[text.opstr for text in line]}")
            if len(line) == 1:
                # Puede ser NOP ó RET
                lit_value = int(0).to_bytes(2)
                match line[0].opstr:
                    case "NOP":
                        opcode = dict_opcodes.get("NOP")
                    case "RET":
                        step_1, opcode = dict_opcodes.get("RET")
                        # Forzamos inyección
                        stringed_form = ''.join(f'{byte:08b}' for byte in lit_value)
                        total = stringed_form + step_1
                        total_int = int(total, 2)
                        order = total_int.to_bytes(5)
                        self.instructions.extend(order)
            elif len(line) == 2:
                # AQQQQUUIIIIIIIIII
                identifier = line[0].opstr + ' ' + line[1].opstr
                match [line[0].opstr, line[1].opstr]:
                    case ["INC"|"DEC", "A"]:
                        opcode = dict_opcodes.get(identifier)
                        lit_value = int(1).to_bytes(2)
                    case ["POP", "A"|"B"]:
                        step_1, opcode = dict_opcodes.get(identifier)
                        # Forzamos inyección
                        stringed_form = ''.join(f'{byte:08b}' for byte in lit_value)
                        total = stringed_form + step_1
                        total_int = int(total, 2)
                        order = total_int.to_bytes(5)
                        self.instructions.extend(order)
                        lit_value = int(0).to_bytes(2)
                    case _:
                        opcode = dict_opcodes.get(identifier)
                        lit_value = line[1].value
            elif len(line) == 3:
                identifier = line[0].opstr + ' ' + line[1].opstr + ', ' + line[2].opstr
                opcode = dict_opcodes.get(identifier)
                # necesitamos saber cuál es el lit
                if isinstance(line[1], MinkiDirToken) and not line[1].U_indirect():
                    lit_value = line[1].value
                else:
                    lit_value = line[2].value
            elif len(line) == 0:
                binary_hindex += 1
                continue
            else:
                raise MinkiSyntaxError(line, starts_at + binary_hindex)
            stringed_form = ''.join(f'{byte:08b}' for byte in lit_value)
            try:
                total = stringed_form + opcode
            except TypeError:
                raise MinkiSyntaxError(f"{line}", binary_hindex)
            total_int = int(total, 2)
            order = total_int.to_bytes(5)
            self.instructions.extend(order)
            binary_hindex += 1