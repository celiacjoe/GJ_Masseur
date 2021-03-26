using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
    public bool Started;
    public float Timer;
    public int State;
    public string Phase;
    public float Duration;

    public GameObject Empty;
    public GameObject Layer01;
    public GameObject Layer02;
    public GameObject Layer03;
    public GameObject Layer04;

    public detec S_Detec;
    public LEAP_ControlSender S_LeapControl;

    // Start is called before the first frame update
    void Start()
    {
        Started = false;

        Phase = "zero";
        Layer01.SetActive(false);
        Layer02.SetActive(false);
        Layer03.SetActive(false);
        Layer04.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("space"))
        {
            Started = true;
        }

        if (Started == true)
        {
            Timer += Time.deltaTime;
        }

        if (Timer > Duration)
        {
            State++;
            Timer = 0;
        }

        if (State == 1)
        {
            Phase = "PHASE 1 OK";
            S_Detec._img1 = 0.6f;
            Debug.Log("PHASE 1 OK");
        }
        else if (State == 2)
        {
            S_Detec._img2 = 0.6f;
            Layer01.SetActive(true);
            S_LeapControl.OBJ = Layer01;
            Phase = "PHASE 2 OK";
        }
        else if (State == 3)
        {
            S_Detec._img3 = 0.6f;
            S_LeapControl.OBJ = Layer02;
            Layer02.SetActive(true);
            Phase = "PHASE 3 OK";
        }
        else if (State == 4)
        {
            S_LeapControl.OBJ = Layer03;
            Layer03.SetActive(true);
            Phase = "PHASE 4 OK";
        }
        else if (State == 5)
        {
            S_LeapControl.OBJ = Layer04;
            Layer04.SetActive(true);
            Phase = "Last";
            Started = false;
        }
        else if (State == 5)
        {
            S_LeapControl.OBJ = Empty;
            Phase = "FINISH";
        }


            if (Input.GetKeyDown("r"))
        {
             Application.LoadLevel(Application.loadedLevel);
        }

        if (Input.GetKeyDown("s"))
        {
            Timer = 0;
        }
    }
}
