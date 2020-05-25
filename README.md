# Make Arxiv zip
Generates a ready to submit arXiv zip file out of your paper.

In the folder containing your paper, run
```bash
curl -sLf https://raw.githubusercontent.com/pantonante/make_arxiv_submission/master/mkarxiv.sh | bash
```

You will see `arxiv_submission.zip` file appear in the current directory.
Just upload this file to arXiv and you are (hopefully) done :+1:!

## FAQ

### I get a warning for my bbl file version

At the moment arXiv runs `biblatex` 3.7, which expects `.bbl` file version 2.8.
That means that the `.bbl` file you upload should be produced by `biblatex` 3.7 and Biber 2.7 (`biblatex` 3.5 or 3.6 with Biber 2.6 would also be OK).
This might not be an issue for you, but if you run into errors in the `.bbl` try to re-compile your LaTeX source with the correct versions of `biblatex` or Biber (e.g. TeXLive 2017).

## Acknowledgment

- Toni Rosinol for his first version of this tool
- [latexpand](https://gitlab.com/latexpand/latexpand)
