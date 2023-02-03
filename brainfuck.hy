(import sys [argv stdin stdin])


(setv program []
      stack []
      data (lfor i (range 30000) 0)
      instruction 0
      data-pointer 0)

(defn load [path]
  (setv sauce (open path))
  (for [instr (sauce.read)]
    (if (in instr ["+" "-" "<" ">" "." "," "[" "]"])
      (program.append instr)))
  (sauce.close))

(defn run []
  (global instruction
          data-pointer)
  (while (<= instruction (len program))
    (match (get program instruction)
      "+" (setv (get data data-pointer) (% (+ (get data data-pointer) 1) 256))
      "-" (setv (get data data-pointer) (% (- (get data data-pointer) 1) 256))
      "<" (setv data-pointer (% (+ data-pointer 1) 30000))
      ">" (setv data-pointer (% (- data-pointer 1) 30000))
      "." (print (chr (get data data-pointer)) :end "")
      "," (setv (get data data-pointer) (ord (stdin.read 1)))
      "[" (if (get data data-pointer)
            (stack.append instruction)
            (do
              (setv s 1)
              (while s
                (+= instruction 1)
                (+= s (match (get program instruction)
                        "["  1
                        "]" -1)))))
      "]" (setv instruction (- 1 (stack.pop))))
    (+= instruction 1)))

(defn main []
  (if (> (len argv) 1)
    (load (get argv 1))
    (do
      (print "Please provide a brainfuck source file")
      (quit 1)))
  (run))


(if (= __name__ "__main__")
  (main))
