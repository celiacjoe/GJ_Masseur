using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Voice : MonoBehaviour
{
    public float time = 0;
    public string word;
    void Start()
    {
      word = WorldGenerator.GetRandomWord();

    }
    
    // Update is called once per frame
    void Update()
    {
        time += Time.deltaTime;

        if (time >= 2)

        {
            WindowsVoice.speak("Draw a " + word);
        }
        }
}
