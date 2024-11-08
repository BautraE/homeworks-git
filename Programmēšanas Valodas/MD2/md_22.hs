{-
   Edgars Bautra
   eb21122
   MD2-2
-}
{-
   Koka datu tipa definīcija:
   Tiek definēts jauns datu tips "TTT", kas pieņems vienu parametru
   ar tipu "aa".
   Definīcijā ir iekļauti 4 konstruktori, kur katrs atbilst kādam konkrētam
   bērnu skaitam kādai koka virsotnei (0, 1, 2 vai 3). Katram konstruktoram 
   ir klāt saraksts ar elementiem, kā arī citas koka virsotnes, kas ir 
   bērni kādai konkrētai virsotnei.
   Ar "deriving (Show)" tiek uzstatīts ierobežojums jebkuram šī tipa izveidotam
   kokam, kas ļaus tos drukāt ar funkciju "print".
-}
data TTT aa = Nodes0 [aa]
            | Nodes1 [aa] (TTT aa)
            | Nodes2 [aa] (TTT aa) (TTT aa)
            | Nodes3 [aa] (TTT aa) (TTT aa) (TTT aa)
            deriving (Show)

-- Funkcija, kas kāpina padoto vērtību kvadrātā
a :: Integer -> Integer
a val = val^2

-- Funkcija, kas iegūst atlikumu no padotās vērtības, dalot to ar 11
b :: Integer -> Integer
b val = mod val 11

-- Funkcija, kas Kāpina kvadrātā atlikumu no vērtības, dalot to ar 11
c :: Integer -> Integer
c val = a (b val)

{- 
   Funkcijas "mm" definīcija:
   Funkcija "mm" kā argumentus pieņems funkciju "f", kas kaut ko dara ar
   konkrēto vērtibu un atgriež to ar izmaiņām, nemainot tās tipu "(aa -> aa)",
   kā arī koku ar datu tipu "TTT aa".
   Funkcija atgriezīs arī koku ar šo pašu datu tipu - "TTT aa"

   Funkcijas darbības apraksts:
   - Funkcija "mm" tiek izsaukta uz koka virsotni. Sākot ar šo virsotni
     tiek sākta koka apstrāde.
   - Ja virsotnei nav bērni, tiek izsaukts attiecīgais "TTT aa" konstruktors,
     kam padod šīs virsotnes sarakstu, kura visiem elementiem pielieto funkciju "f"
     ar funkcijas "map" palīdzību.
   - Ja virsotnei ir vismaz viens bērns, tad tiek izsaukts attiecīgais "TTT aa"
     konstruktors, kam padod virsotnes pašreizējo sarakstu pēc tā, kad tam pielieto
     funkcijai "mm" padoto funkciju ar funkcijas "map" palīdzību. Katram šīs virsotnes
     bērnam tiek rekursīvi izsaukta šī pati funkcija "mm", kurai padod to pašu
     "f" un attiecīgo bērna virsotni.
   - Konstruktori tiek saukti tāpēc, ka Haskell neparedz mainīt vērtības, bet
     gan izveidot jaunu instanci ar jauno vērtību.
-}
mm :: (aa -> aa) -> TTT aa -> TTT aa
mm f (Nodes0 l) = Nodes0 (map f l)
mm f (Nodes1 l child1) = Nodes1 (map f l) (mm f child1)
mm f (Nodes2 l child1 child2) = Nodes2 (map f l) (mm f child1) (mm f child2)
mm f (Nodes3 l child1 child2 child3) = Nodes3 (map f l) (mm f child1) (mm f child2) (mm f child3)

-- Testi
-- Definē TTT koku, ar ko tiks demonstrēta funkciju darbība:
someTree :: TTT Integer
someTree = Nodes2 [1, 2, 3, 4, 5] 
            (Nodes0 [12, 11, 10]) (Nodes1 [-13, 101, -22, 0] 
                (Nodes3 [7, 8]
                    (Nodes0 [18, 121]) (Nodes0 [1111]) (Nodes0 [-15])))

-- Funkcija, kas izdrukās oriģinālo koku, ar kuru tiks veikti testi:
original :: IO ()
original = do
    putStrLn ("Original tree:")
    print (someTree)

-- Testa funkcija, kur pielieto funkciju "a" izveidotajam kokam:
ff_a :: IO ()
ff_a = do
    putStrLn ("Function a test:")
    print (mm a someTree)

-- Testa funkcija, kur pielieto funkciju "b" izveidotajam kokam:
ff_b :: IO ()
ff_b = do
    putStrLn ("Function b test:")
    print (mm b someTree)

-- Testa funkcija, kur pielieto funkciju "c" izveidotajam kokam:
ff_c :: IO ()
ff_c = do
    putStrLn ("function c test:")
    print (mm c someTree)

main :: IO()
main = do
    original
    ff_a
    ff_b
    ff_c