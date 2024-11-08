-- Oriģinālais variants bb funkcijai
bb :: (Eq keyA, Eq keyB, Eq valueB) => Dictionary keyA keyB -> Dictionary keyB valueB -> Dictionary keyA valueB
bb dictionaryA dictionaryB = go dictionaryA []
  where
    go [] dictionaryC = dictionaryC
    go ((key, value):pairs) dictionaryC = case [valueB | (keyB, valueB) <- dictionaryB, keyB == value] of
        [] -> go pairs dictionaryC
        valuesB -> go pairs (dictionaryC ++ [(key, valueB) | valueB <- valuesB, notElem (key, valueB) dictionaryC])

-- Variants, kur key value
bb :: (Eq key, Eq value) => Dictionary key value -> Dictionary value value -> Dictionary key value
bb dictionaryA dictionaryB = go dictionaryA []
  where
    go [] dictionaryC = dictionaryC
    go ((key, value):pairs) dictionaryC = case [valueB | (keyB, valueB) <- dictionaryB, keyB == value] of
        [] -> go pairs dictionaryC
        valuesB -> go pairs (dictionaryC ++ [(key, valueB) | valueB <- valuesB, notElem (key, valueB) dictionaryC])

-- Variants, kur value value un tiek izmantota union funkcija
bb :: (Eq value) => Dictionary value value -> Dictionary value value -> Dictionary value value
bb dictionaryA dictionaryB = go dictionaryA []
  where
    go [] dictionaryC = dictionaryC
    go ((key, value):pairs) dictionaryC = case [valueB | (keyB, valueB) <- dictionaryB, keyB == value] of
        [] -> go pairs dictionaryC
        valuesB -> go pairs (union dictionaryC [(key, valueB) | valueB <- valuesB])


main :: IO ()
main = do
    putStrLn "Hello, World!"
    -- Define the dictionary directly as a list of key-value pairs
    let dictionary1 = [("hello", "hola"), ("goodbye", "adios"), ("thank you", "gracias"), ("paldies", "gracias")]
    -- List of keys
    let keys = ["hello", "goodbye", "thank you", "thank you", "paldies"]
    -- Translate the keys
    let result1 = aa keys dictionary
    -- Print the result
    print result1  -- Output: ["hola", "adiós", "gracias"]

    let dictionaryA1 = [("a", "b")]
    let dictionaryB1 = [("b","c"), ("b","d")]
    let dictionaryC1 = bb dictionaryA1 dictionaryB1
    print dictionaryC1
    let dictionaryA2 = [("a", "b"), ("a", "d"), ("a", "e")]
    let dictionaryB2 = [("b","c"), ("d","c")]
    let dictionaryC2 = bb dictionaryA2 dictionaryB2
    print dictionaryC2

    let dictionaryCC = [(1,2),(2,3),(3,1)]
    let (m, resultDict) = cc dictionaryCC
    print "test"
    print resultDict
    print m

    ------------------------------------------------------------------------------------
    type Dictionary key value = [(key, value)]

union :: (Eq value) => Dictionary value value -> Dictionary value value -> Dictionary value value
union dictionaryA dictionaryB = dictionaryA ++ [(key, value) | (key, value) <- dictionaryB, notElem (key, value) dictionaryA]

bb :: (Eq value) => Dictionary value value -> Dictionary value value -> Dictionary value value
bb dictionaryA dictionaryB = go dictionaryA []
  where
    go [] dictionaryC = dictionaryC
    go ((key, value):pairs) dictionaryC = case [valueB | (keyB, valueB) <- dictionaryB, keyB == value] of
        [] -> go pairs dictionaryC
        valuesB -> go pairs (union dictionaryC [(key, valueB) | valueB <- valuesB])

-----------------------------------------------------------------------------------------
-- Uzdevums C
cc :: (Eq value) => Dictionary value value -> (Int, Dictionary value value)
cc dictionary = go 1 dictionary
  where
    go m currentDictionary =
        let nextDictionary = union currentDictionary (bb currentDictionary dictionary)
        in if currentDictionary == nextDictionary
        then (m, currentDictionary)
        else go (m+1) nextDictionary
        
main :: IO ()
main = do
    let dictionaryA1 = [("a", "b")]
    let dictionaryB1 = [("b","c"), ("b","d")]
    let dictionaryC1 = bb dictionaryA1 dictionaryB1
    print dictionaryC1
    let dictionaryA2 = [("a", "b"), ("a", "d"), ("a", "e")]
    let dictionaryB2 = [("b","c"), ("d","c")]
    let dictionaryC2 = bb dictionaryA2 dictionaryB2
    print dictionaryC2

    -- let dictionaryCC = [(1,2),(2,3),(3,1)]
    -- let (m, resultDict) = cc dictionaryCC
    -- print "test"
    -- print resultDict
    -- print m
    
    
    