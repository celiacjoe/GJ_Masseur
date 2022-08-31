using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Timer : MonoBehaviour
{
    public GameObject Timer;
    private Animator AC_Timer;
    public S_Manager Manager;
    public S_Text Text;

    public
    void Start()
    {
       AC_Timer = Timer.GetComponent<Animator>();
        
    }

    void Update()
    {
        if (Manager.Phase == "Finished")
        {
            AC_Timer.GetBool("GameIsRunning");
            AC_Timer.SetBool("GameIsRunning",false);
        }
        if (Input.GetKeyDown("f"))
        {
          //  Flash();
        }
    }

    public void StartTimerJ1() {
        AC_Timer.GetBool("GameIsRunning");
        AC_Timer.SetBool("GameIsRunning", true);
        Text.InfoJ1();
        Debug.Log("TimerJ1");
        AC_Timer.SetTrigger("PlayTimerJ1");

    }

    public void StartTimerJ2()
    {
        Text.InfoJ2();
        Debug.Log("TimerJ2");
        AC_Timer.SetTrigger("PlayTimerJ2");
    }

    public void StartTimer()
    {
        AC_Timer.SetTrigger("TimerPlay");
        Debug.Log("Timer General");
    }

   public void EndRound()
    {
        Manager.NextRound();
    }


}
