# TesseractCore

TesseractCore defines the model, evaluation, and semantics (the Core) of a visual dataflow programming environment (Tesseract). The basic model in TesseractCore is a `Graph<T>`, which is a simple directed graph; Tesseract allows you to create, edit, and inspect such graphs with an idiomatic UI.

When specialized to `Graph<Node>`, graphs are assigned a semantics:

- `Node`s have `Symbol`s.
- `Symbol`s are assigned `Value`s in the `Environment`.
- Evaluating a `Graph<Node>` starting from a specific node evaluates all of the input `Node`s, resolves its `Symbol` to a `Value` in the `Environment`, and applies the `Value` to the dependency `Value`s (if any).
