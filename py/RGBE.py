def text_to_rgb(text):
    ascii_values = [ord(c) for c in text]
    while len(ascii_values) % 3 != 0:
        ascii_values.append(0)
    rgb_values = [tuple(ascii_values[i:i+3]) for i in range(0, len(ascii_values), 3)]
    return rgb_values

def rgb_to_text(rgb_values):
    ascii_values = [val for rgb in rgb_values for val in rgb if val != 0]
    return ''.join(chr(val) for val in ascii_values)

def rgb_to_hex(rgb_values):
    return ['#' + ''.join([format(val, '02x') for val in rgb]) for rgb in rgb_values]

def hex_to_rgb(hex_values):
    rgb_values = []
    for hex_val in hex_values:
        hex_val = hex_val.lstrip('#')
        try:
            rgb_values.append(tuple(int(hex_val[i:i+2], 16) for i in (0, 2, 4)))
        except ValueError:
            print(f"Error: Invalid HEX value {hex_val}. Ensure proper HEX format (e.g., #627275).")
            return []
    return rgb_values

def main():
    while True:
        mode = input("(D)ecode/(E)ncode/(EE) Double Encode/(DD) Double Decode or (Q)uit: ").strip().lower()
        
        if mode == "e":
            text = input("Text (e.g., bruh): ").strip()
            encoded_rgb = text_to_rgb(text)
            print("Encoded RGB:", encoded_rgb)

        elif mode == "d":
            print("Example: For decoding, you could input: (98, 114, 117), (104, 0, 0)")
            encoded_input = input("Enter encoded RGB values (e.g., (72, 101, 108)): ").strip()
            try:
                rgb_values = eval(encoded_input)
                decoded_text = rgb_to_text(rgb_values)
                print("Decoded Text:", decoded_text)
            except (NameError, SyntaxError):
                print("Error: Invalid input. Please enter RGB values in the correct format, e.g., (72, 101, 108).")

        elif mode == "ee":
            text = input("Text (e.g., bruh): ").strip()
            encoded_rgb = text_to_rgb(text)
            encoded_hex = rgb_to_hex(encoded_rgb)
            print("Encoded RGB:", encoded_rgb)
            print("Encoded HEX:", encoded_hex)

        elif mode == "dd":
            encoded_input = input("Enter encoded HEX values (e.g., #627275 #680000): ").strip()
            hex_values = encoded_input.replace('[', '').replace(']', '').replace("'", "").split()
            if not hex_values:
                print("Error: No input provided. Please enter valid HEX values.")
                continue
            rgb_values = hex_to_rgb(hex_values)
            if rgb_values:
                print("Decoded RGB:", rgb_values)
                decoded_text = rgb_to_text(rgb_values)
                print("Decoded Text:", decoded_text)

        elif mode == "q":
            break
        else:
            print("Invalid option. Please select (D)ecode, (E)ncode, (EE) Double Encode, (DD) Double Decode, or (Q)uit.")

main()
