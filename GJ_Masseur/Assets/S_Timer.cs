using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Timer : MonoBehaviour
{
    public GameObject Timer;
    private Animator AC_Timer;
    public S_Manager Manager;
    public S_Text Text;
    public float Time;
    public string word;

    void Start()
    {
        word = WorldGenerator.GetRandomWord();
        AC_Timer = Timer.GetComponent<Animator>();
        AC_Timer.GetBool("PlayTimerVoice");
        AC_Timer.SetBool("PlayTimerVoice", false);
    }

    void Update()
    {
        if (Manager.Phase == "Finished")
        {
            AC_Timer.GetBool("GameIsRunning");
            AC_Timer.SetBool("GameIsRunning",false);
        }
    }

    public void StartTimerJ1() {
        Text.InfoJ1();
        AC_Timer.SetTrigger("PlayTimerJ1");
    }

    public void StartTimerJ2()
    {
        Text.InfoJ2();
        AC_Timer.SetTrigger("PlayTimerJ2");
    }

    public void StartTimerVoice()
    {
        word = WorldGenerator.GetRandomWord();
        AC_Timer.GetBool("PlayTimerVoice");
        AC_Timer.SetBool("PlayTimerVoice", true);
        WindowsVoice.speak("Draw me a " + word);
    }

    public void RepeatVoice()
    {
        WindowsVoice.speak("Draw me a " + word);
    }


    public void EndRound()
    {       
        Manager.NextRound();
    }

    public void PlayEndTimer()
    {
       AC_Timer.SetTrigger("End");
       AC_Timer.GetBool("PlayTimerVoice");
       AC_Timer.SetBool("PlayTimerVoice", false);
    }


}
