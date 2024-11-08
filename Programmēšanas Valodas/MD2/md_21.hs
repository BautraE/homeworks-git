{-
Edgars Bautra
eb21122
MD2-1
-}

{- 
  Tiek definēta vārdnīcas datu struktūra ar parametriem "key" un "value".
  Tālāk tiek piesaistīta definīcija izveidotajai datu struktūrai. 
-}
type Dictionary key value = [(key, value)]

{-
  Tiek definēta palīgfunkcija, kuru izmantos gan bb, gan cc funkcija.
  Šī funkcija apvieno divas tai padotās vārdnīcas, klāt arī veicot
  pārbaudi pret dublikātiem.
  Funkcija iterē cauri visiem 2. vārdnīcas pāriem un pārbauda, vai
  tie jau neeksistē iekš 1. vārdnīcas. Ja neeksistē, tie tiek pievienoti
  sarakstam. Beigās pie 1. vārdnīcas tiek pievienots klāt iegūtais saraksts.
-}
union :: (Eq value) => Dictionary value value -> Dictionary value value -> Dictionary value value
union dictionaryA dictionaryB = dictionaryA ++ [(key, value) | (key, value) <- dictionaryB, notElem (key, value) dictionaryA]

-----------------------------------------------------------------------------------------
-- Uzdevums A
{-
  Tiek definēta pirmā funkcija "aa". Ar "(Eq key, Eq value)" tiek noteikti
  ierobežojumi argumentu tipiem "key" un "value", kas ļaus tos salīdzināt.
  Tiek arī definēts, ka funkcija sagaida sev ievadā sarakstu un vārdnīcu
  un atgriezīs citu sarakstu.

  Funkcijas darbība: 
    * Darbinot funkciju "aa" ar atslēgu saraksta un vārdnīcas argumentiem, tiek 
      izmantota palīgfunkcija "go", kas sagaidīs atslēgu sarakstu un rezultātu sarakstu
      kā savus argumentus. Sākotnēji rezultātu saraksts ir tukšs. Šī "go" funkcija tiks
      saukta iteratīvi, kamēr nebeigsies tai padotās atslēgas.
    * Ja tiks saņemts tukšs atslēgu saraksts, tiks atgriezts rezultātu saraksts "aa" 
      funkcijas izsaukumam. 
    * Ja atslēgu sarakstā būs kaut kas, tas tiek apzīmēts ar "(key:keys)", kur "key"
      ir pirmais saraksta elements un "keys" ir atlikušais saraksts bez pirmā elementa.
    * Ar "lookup" funkciju tiek pārbaudīts, vai vārdnīcā ir tulkojums 
      attiecīgai atslēgai.
    * Ja ir tulkojums, tad pārbauda, vai šis tulkojums jau eksistē rezultātu sarakstā.
    * Ja tulkojums ir rezultātu sarakstā, nekas sarakstam klāt netiek pievienots un
      palaiž nākamo "go" iterāciju ar atlikušo atslēgu sarakstu.
    * Pretēji, palaiž nākamo "go" funkcijas iterāciju ar atlikušo atslēgu sarakstu 
      un rezultāta saraksta beigās pieliek atrasto tulkojumu.
-}
aa :: (Eq key, Eq value) => [key] -> Dictionary key value -> [value]
aa keys dictionary = go keys []
  where 
    go [] results = results
    go (key:keys) results = case lookup key dictionary of
      Just value -> 
        if value `elem` results then go keys results
        else go keys (results ++ [value])
      Nothing -> go keys results

-----------------------------------------------------------------------------------------
-- Uzdevums B
{-
  Tiek definēta otra funkcija. Funkcija ievadā sagaida divas vārdnīcas un atgriezīs
  vienu vārdnīcu. Ar "Eq value" tiek noteikts ierobežojums argumentu tipam "value",
  ļaujot tā tipa vētībām tikt salīdzinātām.

  Funkcijas darbība:
    * Darbinot funkciju bb, tiek izmantota palīgfunkcija "go", kas sagaidīs
      divas vārdnīcas kā argumentus. Sākotnēji tā tiks izsaukta ar vienu no
      vārdnīcām un tukšu sarakstu.
    * Ja "go" saņems tukšu vārdnīcu un gala vārdnīcu, tiks atgriezta gala
      vārdnīca.
    * Ja "go" saņems divas vārdnīcas, pirmā tiek apzīmēta šādi "((key, value):pairs)", kas
      nodrošinās piekļuvi pirmā vārdnīcas pāra atslēgai un vērtībai, kā arī sarakstam
      ar atlikušajiem pāriem, neskaitot pirmo.
    * Šinī gadījumā tiks iterēts cauri otrās vārdnīcas pāriem, salīdzinot pirmās vārdnīcas
      vērtību ar otrās vārdnīcas atslēgu. Ja sakritīs, tad otrās vārdnīcas vērtība tiek
      ielikta atsevišķā sarakstā.
    * Ja šis saraksts būs tukšs, tiek izsaukta go funkcija, lai pārbaudītu atlikušos pirmās
      vārdnīcas pārus.
    * Ja šis saraksts nebūs tukšs, tiek izsaukta go funkcija, kurai padod atlikušos pirmās
      vārdnīcas pārus un apvienojumu starp pašreizējo gala vārdnīcu un tikko iegūto jauno
      pāru sarakstu, kas tiek izveidots, pievienojot katrai vērtībai pirmās vārdnīcas atslēgu.
      (Pārbaudi uz dublikātiem pārbauda funkcija "union")

-}
bb :: (Eq value) => Dictionary value value -> Dictionary value value -> Dictionary value value
bb dictionaryA dictionaryB = go dictionaryA []
  where
    go [] dictionaryC = dictionaryC
    go ((key, value):pairs) dictionaryC = case [valueB | (keyB, valueB) <- dictionaryB, keyB == value] of
        [] -> go pairs dictionaryC
        valuesB -> go pairs (union dictionaryC [(key, valueB) | valueB <- valuesB])

-----------------------------------------------------------------------------------------
-- Uzdevums C
{-
  Tiek definēta trešā funkcija. Funkcija ievadā sagaida vārdnīcu un atgriezīs pāri ar
  skaitli un vārdnīcu. Ar "Eq value" tiek noteikts ierobežojums argumentu tipam "value",
  ļaujot tā tipa vētībām tikt salīdzinātām.

  Funkcijas darbība:
    * Darbinot funkciju cc, tiek izsaukta palīgfunkcija "go", kas sagaidīs skaitli un
      vārdnīcu kā argumentus. Sākotnēji "go" tiek izsaukts ar skaitli 1 un funkcijai
      cc padoto vārdnīcu.
    * Saņemot ievadā skaitli un vārdnīcu, funkcija "go" definē mainīgo "nextDictionary",
      kas saturēs jauniegūto slēgumu, kāds būtu ar M+1.
    * Lai iegūtu šo slēgumu, pamanīju iespēju izmantot jau iepriekš izveidoto funkciju
      bb, kas veiktu kompozīcijas darbību starp pašreizējo vārdnīcu un sākotnējo.
      Pašreizējā vārdnīca tiek apvienota ar iegūto kompozīciju ar "union" funkcijas
      palīdzību.
      (Pārbaude uz dublikātiem tiek veikta funkcijā "union")
    * Ja jauniegūtā vārdnīca sakrīt ar pašreizējo (jauns pāris kompozīcijas rezultātā
      netika iegūts), tiek atgriezts pāris ar pašreizējo M vērtību un pašreizējo
      gala vārdnīcu.
    * Ja jauniegūtā vārdnīca nesakrīt ar pašreizējo (tika iegūts jauns pāris kompozīcijas
      rezultātā), tiek izsaukta go funkcija, kur M tiek palielināts par 1 un pašreizējā
      vārdnīca tiek aizvietota ar jauniegūto.

  Skaidrojums par M (Kāpēc atrastais M ir mazākais pilnības skaitlis?):
  Izdotais skaitlis M ir mazākais pilnības skaitlis, jo sākot ar šo skaitli ir panākta
  padotās vārdnīcas pilnība, iteratīvi izpildot šo darbību: A(n+1) = A(n) ∪ (A(n) o A)
  Tas ir mazākais, jo šo pašu pilnību var panākt ar bezgalīgi merāmu iterāciju skaitu,
  taču vārdnīcas saturs vairs nemainīsies.
  Citiem vārdiem sakot, vārdnīcas pilnība tiek sasniegta pēc M soļiem, kur katrs solis
  ir jau iepriekš minētā darbība.
-}
cc :: (Eq value) => Dictionary value value -> (Int, Dictionary value value)
cc dictionary = go 1 dictionary
  where
    go m currentDictionary =
        let nextDictionary = union currentDictionary (bb currentDictionary dictionary)
        in if currentDictionary == nextDictionary
        then (m, currentDictionary)
        else go (m+1) nextDictionary

-----------------------------------------------------------------------------------------
-- Funkciju testi
-- aa1 testa vārdnīca
aa1d :: Dictionary String String
aa1d = [("CPU", "central processing unit"),
        ("GPU", "graphics processing unit"), 
        ("PSU", "power supply unit"),
        ("RAM", "random access memory"),
        ("DVI", "digital visual interface")]

-- aa1 testa atslēgu saraksts
aa1keys :: [String]
aa1keys = ["CPU", "DVI", "GPU", "RAM", "PSU", "DDR", "CPU"]

-- aa1 tests
aa1 :: IO ()
aa1 = do
  putStrLn "aa test 1:"
  print (aa aa1keys aa1d)
  {- 
    Sagaidāmā izvade:
    ["central processing unit","digital visual interface",
    "graphics processing unit","random access memory",
    "power supply unit"]
  -}

-- aa2 testa vārdnīca
aa2d :: Dictionary Int String
aa2d = [(10, "ten"),
        (20, "twenty"),
        (30, "thirty"),
        (40, "forty"),
        (50, "fifty")]

-- aa2 testa atslēgu saraksts
aa2keys :: [Int]
aa2keys = [10, 20, 30, 50, 40, 60, 20]

-- aa2 tests
aa2 :: IO ()
aa2 = do
  putStrLn "\naa test 2:"
  print (aa aa2keys aa2d)
  {- 
    Sagaidāmā izvade:
    ["ten","twenty","thirty","fifty","forty"]
  -}

-- bb1 testa vārdnīca 1
bb1d1 :: Dictionary String String
bb1d1 = [("chocolate", "confectionery"), 
          ("cookie", "confectionery"), 
          ("apple", "fruit"), 
          ("carrot", "vegetable"), 
          ("cheese", "dairy"), 
          ("banana", "fruit"), 
          ("milk", "dairy"), 
          ("broccoli", "vegetable")]

-- bb1 testa vārdnīca 2
bb1d2 :: Dictionary String String
bb1d2 = [("confectionery", "unhealthy"), 
          ("confectionery", "sweet"), 
          ("fruit", "healthy"), 
          ("fruit", "sweet"), 
          ("vegetable", "healthy"), 
          ("dairy", "calcium-rich")]

-- bb1 tests
bb1 :: IO ()
bb1 = do
  putStrLn "\nbb test 1:"
  print (bb bb1d1 bb1d2)
  {- 
    Sagaidāmā izvade:
    [("chocolate","unhealthy"),("chocolate","sweet"),("cookie","unhealthy"),
    ("cookie","sweet"),("apple","healthy"),("apple","sweet"),("carrot","healthy"),
    ("cheese","calcium-rich"),("banana","healthy"),("banana","sweet"),
    ("milk","calcium-rich"),("broccoli","healthy")]
  -}

-- bb2 testa vārdnīca 1
bb2d1 :: Dictionary String String
bb2d1 = [("0", "brand new"),
          ("1000", "very little"), 
          ("10000", "little"),
          ("20000", "little"), 
          ("100000", "moderate"),
          ("300000", "a lot")]

-- bb2 testa vārdnīca 2
bb2d2 :: Dictionary String String
bb2d2 = [("very little", "almost brand new"), 
          ("very little", "no technical issues"),
          ("little", "no technical issues"), 
          ("moderate", "potential rust"),
          ("moderate", "potential technical difficulties"), 
          ("a lot", "potential rust"), 
          ("a lot", "might need repairs")]

-- bb2 tests
bb2 :: IO ()
bb2 = do
  putStrLn "\nbb test 2:"
  print (bb bb2d1 bb2d2)
  {- 
    Sagaidāmā izvade:
    [("1000","almost brand new"),("1000","no technical issues"),("10000","no technical issues"),
    ("20000","no technical issues"),("100000","potential rust"),
    ("100000","potential technical difficulties"),("300000","potential rust"),
    ("300000","might need repairs")]
  -}

-- cc1 testa vārdnīca
cc1d :: Dictionary Int Int
cc1d = [(1,2),(2,3),(3,1),(4,5),(5,4)]

-- cc1 tests
cc1 :: IO ()
cc1 = do
  putStrLn "\ncc test 1:"
  print (cc cc1d)
  {- 
    Sagaidāmā izvade:
    3
    un
    [(1,2),(2,3),(3,1),(4,5),(5,4),(1,3),(2,1),(3,2),(4,4),(5,5),(1,1),(2,2),(3,3)]
  -}

-- cc1 testa vārdnīca
cc2d :: Dictionary String String
cc2d = [("Jurmala", "Riga"),
        ("Tukums", "Kemeri"),
        ("Kandava", "Kuldiga"),
        ("Jelgava", "Tukums"),
        ("Tukums", "Kandava"),
        ("Kemeri", "Jurmala"),
        ("Riga", "Jelgava")]

-- cc1 tests
cc2 :: IO ()
cc2 = do
  putStrLn "\ncc test 2:"
  print (cc cc2d)
  {- 
    Sagaidāmā izvade:
    6
    un
    [("Jurmala","Riga"),("Tukums","Kemeri"),("Kandava","Kuldiga"),("Jelgava","Tukums"),
    ("Tukums","Kandava"),("Kemeri","Jurmala"),("Riga","Jelgava"),("Jurmala","Jelgava"),
    ("Tukums","Jurmala"),("Jelgava","Kemeri"),("Jelgava","Kandava"),("Tukums","Kuldiga"),
    ("Kemeri","Riga"),("Riga","Tukums"),("Jurmala","Tukums"),("Tukums","Riga"),("Jelgava","Jurmala"),
    ("Jelgava","Kuldiga"),("Kemeri","Jelgava"),("Riga","Kemeri"),("Riga","Kandava"),("Jurmala","Kemeri"),
    ("Jurmala","Kandava"),("Tukums","Jelgava"),("Jelgava","Riga"),("Kemeri","Tukums"),
    ("Riga","Jurmala"),("Riga","Kuldiga"),("Jurmala","Jurmala"),("Jurmala","Kuldiga"),
    ("Tukums","Tukums"),("Jelgava","Jelgava"),("Kemeri","Kemeri"),("Kemeri","Kandava"),
    ("Riga","Riga"),("Kemeri","Kuldiga")])
  -}

main :: IO ()
main = do
    aa1
    aa2
    bb1
    bb2
    cc1
    cc2