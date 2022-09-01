using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Timer : MonoBehaviour
{
    public detec S_Detec;
    public GameObject Timer;
    private Animator AC_Timer;
    public S_Manager Manager;
   // public S_PresenceChecker Presence;
    public S_Text Text;
    public float Time;
    public string word;
    public LEAP_ControlSender S_LeapControl;
    public GameObject GO01;
    public GameObject GO02;
    public PostEffect PP;

    void Start()
    {
        AC_Timer = Timer.GetComponent<Animator>();
        AC_Timer.GetBool("PlayTimerVoice");
        AC_Timer.SetBool("PlayTimerVoice", false);
        PP.GetComponent<PostEffect>().effect.SetFloat("_mvt", 0f);
    }

    void Update()
    {
        if (Manager.Phase == "Finished")
        {
            AC_Timer.GetBool("GameIsRunning");
            AC_Timer.SetBool("GameIsRunning", false);
        }

        if (GO01.activeInHierarchy == true || GO02.activeInHierarchy == true)
        {
            if (Manager.Phase == "Tuto")
            {
                Manager.LaunchMenu();
            }
            else if (Manager.Phase == "Menu")
            {
                AC_Timer.GetBool("Presence");
                AC_Timer.SetBool("Presence", true);
            }
        }

        if (Manager.Phase == "Started")
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence", false);
        }

        if (GO01.activeInHierarchy == false && GO02.activeInHierarchy == false)
        {
            AC_Timer.GetBool("Presence");
            AC_Timer.SetBool("Presence", false);
        }
    }

    public void TimerPresenceFull()
    {
        PP.GetComponent<PostEffect>().effect.SetFloat("_mvt", 0f);
        Manager.LaunchGameSession();
    }

    public void StartTimerJ1()
    {
        Text.InfoJ1();
        AC_Timer.SetTrigger("PlayTimerJ1");
        Manager.J2 = false;
        S_LeapControl.OBJ = Manager.LayerEmpty;
    }

    public void StartTimerJ2()
    {
        Text.InfoJ2();
        AC_Timer.SetTrigger("PlayTimerJ2");
        Manager.J2 = true;
        if (Manager.Round == 1)
        {
            S_LeapControl.OBJ = Manager.Layer01;
        }else if (Manager.Round == 2)
        {
            S_LeapControl.OBJ = Manager.Layer02;
        }
        else if (Manager.Round == 3)
        {
            S_LeapControl.OBJ = Manager.Layer03;
        }
        else if (Manager.Round == 4)
        {
            S_LeapControl.OBJ = Manager.Layer04;
        }
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

       S_LeapControl.OBJ = Manager.LayerEmpty;
    }

    public void WavyEffect()//// Launched by animation end
    {
        PP.GetComponent<PostEffect>().effect.SetFloat("_mvt", 1f);
    }


}
