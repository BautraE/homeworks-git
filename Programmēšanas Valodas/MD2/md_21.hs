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
aa1 :: IO ()
aa1 = do
  let dictionary = [("CPU", "central processing unit"),("GPU", "graphics processing unit"),("PSU", "power supply unit"),("RAM", "random access memory"),("DVI", "digital visual interface")]
  let keys = ["CPU", "DVI", "GPU", "RAM", "PSU", "DDR", "CPU"]
  print "aa test 1:"
  print (aa keys dictionary)
  {- 
  Sagaidāmā izvade:
  ["central processing unit","digital visual interface",
  "graphics processing unit","random access memory",
  "power supply unit"]
  -}

aa2 :: IO ()
aa2 = do
  let dictionary = [(10, "ten"),(20, "twenty"),(30, "thirty"),(40, "forty"),(50, "fifty")]
  let keys = [10, 20, 30, 50, 40, 60, 20]
  print "aa test 2:"
  print (aa keys dictionary)
  {- 
  Sagaidāmā izvade:
  ["ten","twenty","thirty","fifty","forty"]
  -}

bb1 :: IO ()
bb1 = do
  let dictionaryA = [("CPU", "central processing unit"),("GPU", "graphics processing unit"),("PSU", "power supply unit"),("RAM", "random access memory"),("DVI", "digital visual interface")]
  let dictionaryB = [("central processing unit", "processor")
  ,("graphics processing unit", )
  ,("graphics processing unit", )
  ,("graphics card", "GPU")
  ,("video card", "GPU")]
  print "bb test 1:"
  print (bb dictionaryA dictionaryB)
  {- 
  Sagaidāmā izvade:
  
  -}

bb2 :: IO ()
bb2 = do
  let dictionaryA = [(10, "ten"),(20, "twenty"),(30, "thirty"),(40, "forty"),(50, "fifty")]
  let dictionaryB = [(), (), (), (), ()]
  print "bb test 2:"
  print (bb dictionaryA dictionaryB)
  {- 
  Sagaidāmā izvade:
  
  -}

cc1 :: IO ()
cc1 = do
  let dictionary = [(1,2),(2,3),(3,1),(4,5),(5,4)]
  print "cc test 1:"
  print (cc dictionary)
  {- 
  Sagaidāmā izvade:
  3
  un
  [(1,2),(2,3),(3,1),(4,5),(5,4),(1,3),(2,1),(3,2),(4,4),(5,5),(1,1),(2,2),(3,3)]
  -}

cc2 :: IO ()
cc2 = do
  let dictionary = [("Jurmala", "Riga"),("Tukums", "Kemeri"),("Kandava", "Kuldiga"),("Jelgava", "Tukums"),("Tukums", "Kandava"),("Kemeri", "Jurmala"),("Riga", "Jelgava")]
  print "cc test 2:"
  print (cc dictionary)
  {- 
  Sagaidāmā izvade:
  
  -}

main :: IO ()
main = do
    aa1
    aa2
    bb1
    bb2
    cc1
    cc2

{- Vēl jautājumi, uz kuriem prasītos atbildēt, jo pašlaik
nav skaidri:
  * "katrai funkcijai abos testpiemēros vārdnīcas satur dažādu tipu
    datu vērtības)" - kas ar šo domāts īsti? Tas ka viens saraksts ir
    ,piemēram, (int, int) un otrs ir (string, string) vai abi
    ir (int, string).
  * "saņemot ieejā homogēnu vārdnīcu A" - tas nozīmē, ka funkcijas
    parametri ir definēti "Dictionary value value" vai pati vārdnīca
    ir definēta "Dictionary key value = [(key, value)]".
  * Vai ir vienalga, ka visām funkcijām definē to parametrus kā
    "Dictionary value value" nevis "Dictionary key value"
-}