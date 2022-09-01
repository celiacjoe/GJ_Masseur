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
    public string Phase;
    public int Round;
    public bool J2;
  //  public Voice S_Voice;
   // public GameObject LayerBase;
    public GameObject Layer01;
    public GameObject Layer02;
    public GameObject Layer03;
    public GameObject Layer04;
    public GameObject LayerEmpty;

    public GameObject Cheker;

    void Start()
    {
        LaunchMenu();
        Phase = "Menu";
        Round = 0;
        Layer01.SetActive(false);
        Layer02.SetActive(false);
        Layer03.SetActive(false);
        Layer04.SetActive(false);
        J2 = false;
    }


    void Update(){
        /////////////////////////////////////////////////// DEBUG
        if (Input.GetKeyDown("a")){
            Phase = "Tuto";
            Debug.Log("Nobody");
        }

        if (Input.GetKeyDown("z")){
            Phase = "Menu";
            Debug.Log("Someone is detected");
        }

        if (Input.GetKeyDown("e")){
            Phase = "Started";
            Debug.Log("A new game is starting !");
        }

        /////////////////////////////////////////////////// PHASE
        if (Phase == "Tuto")
        {
            Cheker.SetActive(true);
        }else if (Phase == "Menu")
        {
            Cheker.SetActive(true);
        }
        else if (Phase == "Started")        /////////////// START
        {
            Cheker.SetActive(false);
            // AC_Transition.GetBool("GameIsRunning");
            // AC_Transition.SetBool("GameIsRunning", true);
            if (Round == 0) ///////////////////////////// Round0
            {              
              //AC_Transition.SetTrigger("PlayNewGame"); // Launch game session
            } else if (Round == 1 && J2==true) ////////////////////// Round01
            {
                S_Detec._img1 = 0.6f;
                Layer01.SetActive(true);
                S_LeapControl.OBJ = Layer01;
            } else if (Round == 2 && J2 == true) ////////////////////// Round02
            {
                S_Detec._img2 = 0.6f;
                Layer02.SetActive(true);
                S_LeapControl.OBJ = Layer02;
            } else if (Round == 3 && J2 == true) ////////////////////// Round03
            {
                S_Detec._img3 = 0.6f;
                S_LeapControl.OBJ = Layer03;
                Layer03.SetActive(true);
            } else if (Round == 4 && J2 == true) ////////////////////// Round04
            {
                S_Detec._img4 = 0.6f;
                S_LeapControl.OBJ = Layer04;
                Layer04.SetActive(true);
            }
        }

    }

    public void LaunchTuto()
    {
        AC_Transition.SetTrigger("PlayTuto");
        Phase = "Tuto";
    }
    public void LaunchMenu()
    {
        AC_Transition.SetTrigger("PlayMenu");
        Phase = "Menu";
    }

    public void LaunchGameSession()
    {
        AC_Transition.SetTrigger("PlayNewGame");
    }
    public void Gamestarted()
    {
        Timer.StartTimerVoice();
        Text.InfoJ1();
        Timer.StartTimerJ1();
        Text.ConsigneOnGame();
        Phase = "Started";
        Round++;
    }

    public void NextRound()
    {
        if (Round < 4)
        {
            Timer.StartTimerJ1();
            Round++;
        }else
        {
            EndOfTheGame();
        }
    }

    public void EndOfTheGame()
    {
        Text.TextEndGame();
        Timer.PlayEndTimer();
        Phase = "Finished";
        Round = 0;
        AC_Transition.SetTrigger("PlayEndGame");// ANIM END
        // AC_Transition.SetBool("GameIsRunning",false);
        S_LeapControl.OBJ = LayerEmpty;
    }
    public void Loop() {//// lAUNCHED AT THE end - TRANSITION TO MENU
        LaunchMenu();
        Phase = "Menu";
    }


}
