-- Koka datu tipa definīcija
data TTT aa = Nodes0 [aa]
            | Nodes1 [aa] (TTT aa)
            | Nodes2 [aa] (TTT aa) (TTT aa)
            | Nodes3 [aa] (TTT aa) (TTT aa) (TTT aa)
            deriving (Show, Eq)

-- Funkcija kāpina padoto vērtību kvadrātā
a :: Integer -> Integer
a val = val^2

-- Funkcija iegūst atlikumu no padotās vērtības, dalot to ar 11
b :: Integer -> Integer
b val = mod val 11

-- Kāpināts kvadrātā atlikums no vērtības, dalot to ar 11
c :: Integer -> Integer
c val = a (b val)

-- Funkcija mm
mm :: (aa -> aa) -> TTT aa -> TTT aa
mm f (Nodes0 l) = Nodes0 (map f l)
mm f (Nodes1 l child1) = Nodes1 (map f l) (mm f child1)
mm f (Nodes2 l child1 child2) = Nodes2 (map f l) (mm f child1) (mm f child2)
mm f (Nodes3 l child1 child2 child3) = Nodes3 (map f l) (mm f child1) (mm f child2) (mm f child3)

-- Testi
-- Define a sample TTT tree
exampleTree :: TTT Integer
exampleTree = Nodes2 [1, 2, 3, 4, 5] 
                    (Nodes0 [12, 11, 10]) 
                    (Nodes1 [-13, 101, -22, 0] (Nodes2 [7, 8]
                                (Nodes0 [18, 121]), (Nodes0 [1111])))

-- [-18, 74, -4, -8, 21, 67, 3, -83, 23, 66, 46, -31]
-- [-29, -9, 62, -31, -99, 97, -44, -97, 27, -25, 88, -54]
-- [-7, -52, 83, -80, -2, -100, -91, 57, 16, 78, -24, 79] 

-- Apply function `a` (square) to all elements in the tree
ff_a :: IO ()
ff_a = print(mm a exampleTree)

-- Apply function `b` (mod 11) to all elements in the tree
ff_b :: IO ()
ff_b = print(mm b exampleTree)

-- Apply function `c` (square of mod 11) to all elements in the tree
ff_c :: IO ()
ff_c = print(mm c exampleTree)

main :: IO()
main = do
    -- let testvar = 11
    -- print (a testvar)
    -- print (b testvar)
    -- print (c testvar)
    -- print (exampleTree)
    -- print (resultA)
    -- print (resultB)
    -- print (resultC)
    ff_a
    ff_b
    ff_c