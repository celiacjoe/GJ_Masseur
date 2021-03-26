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
    // Start is called before the first frame update
    void Start()
    {
        Started = false;

        Phase = "zero";
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
            Debug.Log("PHASE 1 OK");
        }
        else if (State == 2)
        {
            Phase = "PHASE 2 OK";
        }
        else if (State == 3)
        {
            Phase = "PHASE 3 OK";
        }
        else if (State == 4)
        {

            Phase = "FINISH";
            Started = false;
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
