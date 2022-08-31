using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Manager : MonoBehaviour
{
    public Animator AC_Transition;
    public detec S_Detec;
    public S_Text Text;
    public LEAP_ControlSender S_LeapControl;
    public S_Timer Timer;
    public Animator AC_Kinect;
    public bool Started;
    public string Phase;
    public int Round;

   // public GameObject LayerBase;
    public GameObject Layer01;
    public GameObject Layer02;
    public GameObject Layer03;
    public GameObject Layer04;
   // public GameObject Layer05;

    void Start()
    {
        Phase = "Nobody";
        Round = 0;
        AC_Transition.SetBool("PlayTuto", false);
    }


    void Update(){
        /////////////////////////////////////////////////// DEBUG
        if (Input.GetKeyDown("a"))
        {
            Phase = "Nobody";
             Debug.Log("Nobody");
        }

        if (Input.GetKeyDown("z"))
        {
            Phase = "Someone";
             Debug.Log("Someone is detected");
        }

        if (Input.GetKeyDown("e"))
        {
            Phase = "Start";
            Debug.Log("A new game is starting !");
        }

        /////////////////////////////////////////////////// PHASE
        if (Phase == "Nobody")
        {
            AC_Transition.SetBool("PlayTuto", true);
        }else if (Phase == "Someone")
        {
            AC_Transition.SetBool("PlayTuto", false);
        }else if (Phase == "Start")        /////////////// START
        {
            AC_Transition.GetBool("GameIsRunning");
            AC_Transition.SetBool("GameIsRunning", true);

            if (Round == 0)
            {              
              AC_Transition.SetTrigger("PlayNewGame");
            } else if (Round == 1)
            {
                S_Detec._img1 = 0.6f;
                Layer01.SetActive(true);
                S_LeapControl.OBJ = Layer01;
               // Debug.Log("PHASE 1 OK");
            } else if (Round == 2)
            {
                S_Detec._img2 = 0.6f;
                Layer02.SetActive(true);
                S_LeapControl.OBJ = Layer02;
                //Debug.Log("PHASE 2 OK");
            } else if (Round == 3)
            {
                S_Detec._img3 = 0.6f;
                S_LeapControl.OBJ = Layer03;
                Layer03.SetActive(true);
               // Debug.Log("PHASE 3 OK");
            } else if (Round == 4)
            {
                S_Detec._img4 = 0.6f;
                S_LeapControl.OBJ = Layer04;
                Layer04.SetActive(true);
                //Debug.Log("PHASE 4 OK");
            }
        }

    }
    public void LaunchGameSession()
    {
        Timer.StartTimerJ1();
        Text.ConsigneOnGame();
        Text.InfoJ1();
    }
    public void NextRound()
    {
        Timer.StartTimerJ1();
        if (Round < 5)
        {
            Round++;
        }
        else
        {
            EndOfTheGame();
        }
    }

    public void EndOfTheGame()
    {
        Text.TextEndGame();
        AC_Transition.SetBool("GameIsRunning",false);
        
    }


}
