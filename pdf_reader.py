import pathlib
import subprocess
import sys

try:
    from pypdf import PdfReader
except Exception as err:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pypdf"])
    from pypdf import PdfReader


class doc_reader:
    def __init__(self, base="docs"):
        self.base = pathlib.Path(base)

    def scan(self):
        texts = []
        if not self.base.exists():
            print("docs folder missing")
            return texts
        for pdf in self.base.glob("*.pdf"):
            try:
                reader = PdfReader(str(pdf))
                text = ""
                for page in reader.pages:
                    part = page.extract_text()
                    if part:
                        text += part
                texts.append(text)
            except Exception as err:
                print("failed to read " + str(pdf) + ": " + str(err))
        return texts


if __name__ == "__main__":
    reader = doc_reader()
    reader.scan()
