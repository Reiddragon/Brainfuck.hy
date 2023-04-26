#!/usr/bin/env hy
(import sys [argv stdin stdout])

(setv data (* [0] 30000)
      data-pointer 0)

;; loads the source file and strips any non-instructions
(defn load [path]
  (with [file (open path)]
    (lfor instr (.read file)
                 :if (in instr ["+" "-" "<" ">" "." "," "[" "]"]) instr)))

;; This compiles the code to a tree structure
;; The way it works is it slowly consumes the flat instruction list `load` returns, making sure it doesn't end up interpreting an instruction twice
;; This only really works because Python lists are pass-by-reference
;; Every time it reaches a `[` it creates a nested list, and every time it hits
;; a `]` it breaks out of it
;; This means you can also use `]` at the top level to just forcibly quit in
;; this interpreter
(defn comp [code]
  (let [prog []]
    (while (len code)
      (match (setx instr (.pop code 0))
        "[" (prog.append (comp code))
        "]" (break)
        _ (prog.append instr)))

    (return (tuple prog))))

;; The VM is rather uneventful, the only sorta interesting bit is that first it
;; checks the type of the instruction, then if it's a string it interpret it
;; normally, if it's a tuple or list it does a recursive call
(defn run [code]
  (global data-pointer)
  (for [instr code]
    (cond
      (= (type instr) str)
      (match instr
        "+" (setv (get data data-pointer) (% (+ (get data data-pointer) 1) 256))
        "-" (setv (get data data-pointer) (% (- (get data data-pointer) 1) 256))
        "<" (setv data-pointer (% (- data-pointer 1) 30000))
        ">" (setv data-pointer (% (+ data-pointer 1) 30000))
        "." (stdout.write (chr (get data data-pointer)))
        "," (setv (get data data-pointer) (ord (stdin.read 1))))

      (in (type instr) [tuple list])
      (while (!= 0 (get data data-pointer))
        (run instr)))))

(defn main []
  (if (> (len argv) 1)
    (run (comp (load (get argv 1))))
    (do
      (print "Please provide a brainfuck source file")
      (quit 1))))

(when (= __name__ "__main__")
  (main))
