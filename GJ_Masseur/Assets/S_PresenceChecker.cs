using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_PresenceChecker : MonoBehaviour
{
    public S_Timer Timer;
    public S_Manager Manager;
    public float T;
    public bool Someone;
    public GameObject GO01;
    void Start()
    {
        Someone = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (GO01.activeInHierarchy == true && Manager.Phase == "Tuto")
        {
            Manager.LaunchMenu();
            //Someone = true;
        }
        else if (GO01.activeInHierarchy == true && Manager.Phase == "Menu")
        {
            Someone = true;
        }
    }
    private void OnCollisionEnter(Collision col)
    {
          if (col.gameObject.tag == "Hand" && Manager.Phase == "Tuto")
          {
            Manager.LaunchMenu();
            Debug.Log("LaunchMenu cause of presence");
            
        }
    }
    void OnCollisionStay(Collision col)
    {
        if (col.gameObject.tag == "Hand" && Manager.Phase == "Menu")
        {
            //Timer.StartTimerPresence();
            Someone = true;
        }
        else if (col.gameObject.tag == "Hand" && Manager.Phase == "Tuto")
        {
            Someone = true;
        }
    }

    void OnCollisionExit(Collision col)
    {
        if (col.gameObject.tag == "Hand")
        {
            Someone = false;
        }
    }


}
