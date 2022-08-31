using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Voice : MonoBehaviour
{
    public bool VoiceStarted;
    public float T;
    public float time = 0;
    public string word;
    void Start()
    {
      word = WorldGenerator.GetRandomWord();
        VoiceStarted = false;
    }
    
    // Update is called once per frame
    void Update()
    {
        if (VoiceStarted == true)
        {
            time += Time.deltaTime;

            if (time >= T)

            {
                WindowsVoice.speak("Draw me a " + word);
            }

        }

     }

    public void LaunchVoice()
    {
        WindowsVoice.speak("Draw me a " + word);
    }

    public void VoiceEnd()
    {
        WindowsVoice.speak("Is the best " + word +"I Never seen !");
    }
}
