using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class S_Text : MonoBehaviour
{
    public S_Timer Timer;
    public S_Manager Manager;
    public TextMeshPro T_Consigne;
    public TextMeshPro T_J1;
    public TextMeshPro T_J2;
    public TextMeshPro T_Counter;
    public Animator AC_Text;
    //private const string label = "<#0050FF> </color>{0:2}";
    //private float m_frame;

    void Start()
    {
        T_J1.SetText("");
        T_J2.SetText("");
        T_Counter.SetText("");      
    }

    void Update()
    {
        if (Manager.Round == 0)
        {
            T_J1.SetText("J1 use your body to create");
            T_J2.SetText("J2 Compose with the shape");
        }
        else if (Manager.Round == 1)
        {
            T_J1.SetText("J1 it's your turn !");
            T_J2.SetText("J2 Assemble les formes");
            T_Counter.SetText("I");
        }
        else if (Manager.Round == 2)
        {
            T_J2.SetText("J2!");
            T_J1.SetText("J1...");
            T_Counter.SetText("I l");
        }
        else if (Manager.Round == 3)
        {
            T_J1.SetText("J1 it's your last shape!");
            T_J2.SetText("J2 Compose with the last shape!");
            T_Counter.SetText("I l I");
        }
        else if (Manager.Round == 3)
        {
            T_J1.SetText("J1 it's your last shape!");
            T_J2.SetText("J2 Compose with the last shape!");
            T_Counter.SetText("I l I l");

        }


    }
    public void ConsigneOnGame()
    {
        T_Consigne.SetText("Draw a " + Timer.word + " with your body!");
        AC_Text.SetTrigger("SetConsigne");
        AC_Text.GetBool("GameIsRunning");
        AC_Text.SetBool("GameIsRunning", true);
    }

    public void InfoJ1()
    {
        Round();
        AC_Text.SetTrigger("ApparitionTextJ1");
    }
    public void InfoJ2()
    {

      /*  if (Manager.Round == 1)
        {
            T_J2.SetText("J2 Compose with the shape");
        }else if (Manager.Round == 2)
        {
            T_J2.SetText("J2 Assemble les formes");
        }else if (Manager.Round == 3)
        {
            T_J2.SetText("J2!");
        }else if (Manager.Round == 4)
        {
            T_J2.SetText("J2 Compose with the last shape!");
        }*/
        AC_Text.SetTrigger("ApparitionTextJ2");
    }

    public void Round()
    {
       /* if (Manager.Round == 1)
        {
            T_Counter.SetText("I");
        }else if (Manager.Round == 2)
        {
            T_Counter.SetText("I l");
        }else if (Manager.Round == 3)
        {
            T_Counter.SetText("I l I");
        }else if (Manager.Round == 4)
        {
            T_Counter.SetText("I l I l");
        }*/
        AC_Text.SetTrigger("SetCounter");
    }

    public void TextEndGame()
    {
        AC_Text.GetBool("GameIsRunning");
        AC_Text.SetBool("GameIsRunning", false) ;
        T_J1.SetText("");
        T_J2.SetText("");
        T_Counter.SetText("");
        T_Consigne.SetText("");
    }


}