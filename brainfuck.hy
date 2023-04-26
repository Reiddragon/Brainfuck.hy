#!/usr/bin/env hy
(import sys [argv stdin stdout])

(setv data (* [0] 30000)
      data-pointer 0)

(defn load [path]
  (with [file (open path)]
    (lfor instr (.read file)
                 :if (in instr ["+" "-" "<" ">" "." "," "[" "]"]) instr)))

(defn comp [code]
  (let [prog []]
    (while (len code)
      (match (setx instr (.pop code 0))
        "[" (prog.append (comp code))
        "]" (break)
        _ (prog.append instr)))

    (return (tuple prog))))

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

      (= (type instr) tuple)
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
