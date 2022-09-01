using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Timer : MonoBehaviour
{
    public detec S_Detec;
    public GameObject Timer;
    private Animator AC_Timer;
    public S_Manager Manager;
    public S_PresenceChecker Presence;
    public S_Text Text;
    public float Time;
    public string word;

    void Start()
    {
        //word = WorldGenerator.GetRandomWord();
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

        if (Presence.Someone == false)
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence", false);
        }else if(Presence.Someone ==true && Manager.Phase == "Menu")
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence", true);
        }else if (Presence.Someone == true && Manager.Phase == "Menu")
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence", true);
        }
    }

  /*  public void StartTimerPresence() {
        if (Manager.Phase == "Menu" && Presence.Someone==true)
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence",true);
        }
    }*/

    public void TimerPresenceFull()
    {
        Manager.LaunchGameSession();
    }

    public void StartTimerJ1()
    {
        Text.InfoJ1();
        AC_Timer.SetTrigger("PlayTimerJ1");
        Manager.J2 = false;
    }

    public void StartTimerJ2()
    {
        Text.InfoJ2();
        AC_Timer.SetTrigger("PlayTimerJ2");
        Manager.J2 = true;
    }

    public void StartTimerVoice()
    {
        Debug.Log("NEW");
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
       if(Manager.Round ==1)
        {
            S_Detec._img1 = 0.6f;
        }else if (Manager.Round == 2)
        {
            S_Detec._img2 = 0.6f;
        }
        else if (Manager.Round == 3)
        {
            S_Detec._img3 = 0.6f;
        }
        else if (Manager.Round == 4)
        {
            S_Detec._img4 = 0.6f;
        }
        Manager.NextRound();
    }

    public void PlayEndTimer()
    {
       AC_Timer.SetTrigger("End");
       AC_Timer.GetBool("PlayTimerVoice");
       AC_Timer.SetBool("PlayTimerVoice", false);
    }


}
