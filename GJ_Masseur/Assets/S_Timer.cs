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

    }

    public void StartTimerJ1() {
        AC_Timer.GetBool("GameIsRunning");
        AC_Timer.SetBool("GameIsRunning", true);
        Text.InfoJ1();
        //Text.Round();
        AC_Timer.SetTrigger("PlayTimerJ1");

    }

    public void StartTimerJ2()
    {
        Text.InfoJ2();
        AC_Timer.SetTrigger("PlayTimerJ2");
    }


   public void EndRound()
    {       
        Manager.NextRound();
    }

    public void PlayEndTimer()
    {
       AC_Timer.SetTrigger("End");
    }


}
