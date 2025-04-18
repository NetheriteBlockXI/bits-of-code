import os
import base64
import hashlib
import tkinter as tk
from tkinter import filedialog

SECTOR_SIZE = 8  
ROUNDS = 32      
SALT_DIR = 'encryptv2'
SALT_FILE = os.path.join(SALT_DIR, 'encrypt.txt')
DEFAULT_OUTPUT = os.path.join(SALT_DIR, 'output.txt')

def ensure_salt():
    os.makedirs(SALT_DIR, exist_ok=True)
    if not os.path.exists(SALT_FILE):
        salt_input = input("[!] Salt file not found. Enter a salt: ").strip()
        with open(SALT_FILE, 'wb') as f:
            f.write(salt_input.encode())
        print(f"[+] Salt saved to {SALT_FILE}")
    with open(SALT_FILE, 'rb') as f:
        return f.read()

def derive_key_iv(password: str, salt: bytes):
    h = hashlib.sha256(password.encode() + salt).digest()
    key = h[:16]       
    iv = hashlib.sha256(salt + password.encode()).digest()[:8]
    return key, iv

def pad(data: bytes, block_size: int = SECTOR_SIZE) -> bytes:
    pad_len = block_size - (len(data) % block_size)
    return data + bytes([pad_len] * pad_len)

def unpad(data: bytes) -> bytes:
    pad_len = data[-1]
    if pad_len < 1 or pad_len > SECTOR_SIZE:
        raise ValueError("Invalid padding")
    return data[:-pad_len]

def tea_encrypt(block: bytes, key: bytes) -> bytes:
    v0, v1 = int.from_bytes(block[:4], 'big'), int.from_bytes(block[4:], 'big')
    k = [int.from_bytes(key[i:i+4], 'big') for i in range(0,16,4)]
    sum_ = 0
    delta = 0x9E3779B9
    for _ in range(ROUNDS):
        sum_ = (sum_ + delta) & 0xFFFFFFFF
        v0 = (v0 + (((v1<<4) + k[0]) ^ (v1 + sum_) ^ ((v1>>5) + k[1]))) & 0xFFFFFFFF
        v1 = (v1 + (((v0<<4) + k[2]) ^ (v0 + sum_) ^ ((v0>>5) + k[3]))) & 0xFFFFFFFF
    return v0.to_bytes(4,'big') + v1.to_bytes(4,'big')

def tea_decrypt(block: bytes, key: bytes) -> bytes:
    v0, v1 = int.from_bytes(block[:4], 'big'), int.from_bytes(block[4:], 'big')
    k = [int.from_bytes(key[i:i+4], 'big') for i in range(0,16,4)]
    delta = 0x9E3779B9
    sum_ = (delta * ROUNDS) & 0xFFFFFFFF
    for _ in range(ROUNDS):
        v1 = (v1 - (((v0<<4) + k[2]) ^ (v0 + sum_) ^ ((v0>>5) + k[3]))) & 0xFFFFFFFF
        v0 = (v0 - (((v1<<4) + k[0]) ^ (v1 + sum_) ^ ((v1>>5) + k[1]))) & 0xFFFFFFFF
        sum_ = (sum_ - delta) & 0xFFFFFFFF
    return v0.to_bytes(4,'big') + v1.to_bytes(4,'big')

def encrypt_bytes(plain: bytes, password: str, salt: bytes) -> bytes:
    key, iv = derive_key_iv(password, salt)
    data = pad(plain)
    out = iv
    prev = iv
    for i in range(0, len(data), SECTOR_SIZE):
        block = data[i:i+SECTOR_SIZE]
        xored = bytes(a ^ b for a,b in zip(block, prev))
        enc = tea_encrypt(xored, key)
        out += enc
        prev = enc
    return out

def decrypt_bytes(enc: bytes, password: str, salt: bytes) -> bytes:
    key, iv = derive_key_iv(password, salt)
    if len(enc) < SECTOR_SIZE:
        raise ValueError("Ciphertext too short")
    prev = enc[:SECTOR_SIZE]
    data = enc[SECTOR_SIZE:]
    out = b''
    for i in range(0, len(data), SECTOR_SIZE):
        block = data[i:i+SECTOR_SIZE]
        dec = tea_decrypt(block, key)
        plain = bytes(a ^ b for a,b in zip(dec, prev))
        out += plain
        prev = block
    return unpad(out)

def b64e(b: bytes) -> str:
    return base64.b64encode(b).decode()

def b64d(s: str) -> bytes:
    return base64.b64decode(s)

def pick_file(open_mode='r', filetypes=(("All files","*.*"),)):
    root = tk.Tk()
    root.withdraw()
    root.update()
    if open_mode == 'r':
        path = filedialog.askopenfilename(title="Select file", filetypes=filetypes)
    else:
        path = filedialog.asksaveasfilename(title="Save file as", filetypes=filetypes, defaultextension=filetypes[0][1])
    root.destroy()
    return path

def main():
    salt = ensure_salt()
    print("=== Custom Encryptor v3 (TEA-CBC) ===")

    while True:
        cmd = input("\n[e]ncrypt, [d]ecrypt, e[x]it: ").lower().strip()
        if cmd == 'x': break
        if cmd not in ('e','d'): continue

        inp_mode = input("Input from (t) terminal or (f) file picker? (t/f): ").lower().strip()
        if cmd=='e':
            if inp_mode=='f':
                in_path = pick_file('r')
                if not in_path: continue
                with open(in_path,'rb') as f: data = f.read()
            else:
                data = input("Data to encrypt: ").encode()
            pwd = input("Password: ")
            out_bytes = encrypt_bytes(data, pwd, salt)
            out_str = b64e(out_bytes)
        else:
            if inp_mode=='f':
                in_path = pick_file('r',(("Base64 txt","*.txt;*.b64"),("All files","*.*")))
                if not in_path: continue
                with open(in_path,'r') as f: in_str = f.read().strip()
            else:
                in_str = input("Encrypted data (Base64): ").strip()
            pwd = input("Password: ")
            try:
                out_bytes = decrypt_bytes(b64d(in_str), pwd, salt)
                out_str = out_bytes.decode(errors='replace')
            except Exception as e:
                print("Error:", e)
                continue

        out_mode = input("Output to (t) terminal, (d) default file, or (f) pick file? (t/d/f): ").lower().strip()
        if out_mode=='f':
            out_path = pick_file('w',(("Text","*.txt"),("All files","*.*")))
            if not out_path: continue
            mode = 'w' if cmd=='d' else 'w'
            with open(out_path, mode, encoding='utf-8') as f:
                f.write(out_str)
            print(f"Written to {out_path}")
        elif out_mode=='d':
            with open(DEFAULT_OUTPUT,'w',encoding='utf-8') as f:
                f.write(out_str)
            print(f"Written to default output '{DEFAULT_OUTPUT}'")
        else:
            print("\nResult:")
            print(out_str)

if __name__ == "__main__":
    main()
