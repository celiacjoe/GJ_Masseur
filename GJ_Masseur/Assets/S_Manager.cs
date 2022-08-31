using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Manager : MonoBehaviour
{
    public Animator AC_Transition;
  //  public Animator AC_Timer;
    public Animator AC_Kinect;
    public bool Started;
    public string Phase;

    void Start()
    {
        Phase = "Nobody";
        AC_Transition.SetBool("PlayTuto", false);
    }


    void Update(){

        if (Input.GetKeyDown("a"))
        {
            Phase = "Nobody";
            // AC_Timer.SetBool("TimerPlay", true);          
            // AC_Timer.SetTrigger("TimerPlayJ1");
             Debug.Log("Nobody");
        }

        if (Input.GetKeyDown("z"))
        {
            Phase = "Someone";
            // AC_Timer.SetBool("TimerPlay", true);          
            // AC_Timer.SetTrigger("TimerPlayJ1");
             Debug.Log("Someone is detected");
        }

        if (Input.GetKeyDown("e"))
        {
            Phase = "Start";
            //AC_Timer.SetTrigger("TimerPlayJ2");
            Debug.Log("A new game is starting !");
        }

        if (Phase == "Nobody")
        {
            AC_Transition.SetBool("PlayTuto", true);
        }else if (Phase == "Someone")
        {
            AC_Transition.SetBool("PlayTuto", false);
        }else if (Phase == "Start")
        {
            // NewGame();
            AC_Transition.SetTrigger("PlayNewGame");
        }

    }

    void NewGame()
    {
        AC_Transition.SetTrigger("PlayNewGame");
    }
}
