﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
    public bool Started;
    public float Timer;
    public int State;
    public string Phase;
    public float Duration;

    public GameObject ParticulesFin;
    public Animator AC_Timer;
    public GameObject GO_Sphere;

    public GameObject PP;
    public Animator AC_Next;
    public Animator AC_Kinect;
    public GameObject Empty;
    public GameObject LayerBase;
    public GameObject Layer01;
    public GameObject Layer02;
    public GameObject Layer03;
    public GameObject Layer04;
    public GameObject Layer05;
    

    public detec S_Detec;
    public LEAP_ControlSender S_LeapControl;

    Renderer rend;
    // Start is called before the first frame update
    void Start()
    {
        ParticulesFin.SetActive(false);
        Started = false;
        State = 0;
        Phase = "zero";
        Layer01.SetActive(false);
        Layer02.SetActive(false);
        Layer03.SetActive(false);
        Layer04.SetActive(false);

       // ColorChange.GetComponent<Renderer>().material.shader = Shader.Find("Color");
    }

    // Update is called once per frame
    void Update()
    {
      //  ColorChange.GetComponent<Renderer>().material.SetFloat("_WhiteToColor", S_LeapControl.Color);

        if (Input.GetKeyDown("space"))
        {
            State = 0;
            Started = true;
        }

        if (Started == true)
        {
            AC_Timer.SetBool("TimerPlay", true);
            Timer += Time.deltaTime;
            PP.GetComponent<PostEffect>().effect.SetFloat("_flash", GO_Sphere.transform.position.x);
            //PP.effect.SetFloat("_flash", 1f);
        }

        if (Timer > Duration)
        {
            AC_Next.Play("AN_ApparitionInfo");
            AC_Kinect.SetTrigger("T_Flash");
            State++;
            Timer = 0;
        }

        if (State == 0)
        {

        }
        else if (State == 1)
        {
            Phase = "PHASE 1 OK";
            S_Detec._img1 = 0.6f;
            Layer01.SetActive(true);
            S_LeapControl.OBJ = Layer01;
            Debug.Log("PHASE 1 OK");
        }
        else if (State == 2)
        {
            S_Detec._img2 = 0.6f;
            Layer02.SetActive(true);
            S_LeapControl.OBJ = Layer02;
            Phase = "PHASE 2 OK";
        }
        else if (State == 3)
        {
            S_Detec._img3 = 0.6f;
            S_LeapControl.OBJ = Layer03;
            Layer03.SetActive(true);
            Phase = "PHASE 3 OK";
        }
        else if (State == 4)
        {
            S_Detec._img4 = 0.6f;
            S_LeapControl.OBJ = Layer04;
            Layer04.SetActive(true);
            Phase = "PHASE 4 OK";
        }
        else if (State == 5)
        {
            ParticulesFin.SetActive(true);
            AC_Timer.SetBool("TimerPlay", false);
            AC_Kinect.SetBool("Finish", true);
            //AC_Kinect.Play("AN_Focus");
            S_LeapControl.OBJ = Empty;
            Phase = "FINISH";
            Started = false;
            PP.GetComponent<PostEffect>().effect.SetFloat("_mvt", 1f);
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
