using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldGenerator : MonoBehaviour
{
    private static string[] wordList = {   "television", "tree", "monkey", "sun", "gorilla",
                                    "lion", "girafe", "bird", "god", "dog", "cat",
                                    "ninja", "guitare", "hot-dog", "pizza", "tiger", "rhinoceros", "elephant",
                                    "airplane", "car", "truck", "mammoth", "dolphin", "sofa", "dragon",
                                    "squirrel", "spider", "france", "cheese", "shark", "knight",
                                    "cow", "unicorn", "bear", "moon", "robot", "mountain", "computer",
                                      };

    public static string GetRandomWord()
    {
        int randomIndex = Random.Range(0, wordList.Length);
        string randomWord = wordList[randomIndex];

        return randomWord;
    }
}
