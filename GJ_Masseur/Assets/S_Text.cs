using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class S_Text : MonoBehaviour
{
    public Voice S_Voice;
    public S_Manager Manager;

    public TextMeshPro TextPhrase;
    public TextMeshPro TextSession;
    public TextMeshPro T_Consigne;
    public TextMeshPro T_J1;
    public TextMeshPro T_J2;
    public TextMeshPro T_Counter;
    //private TMP_FontAsset m_FontAsset;

    public Animator AC_Text;
    public bool PlayPhrase;

    public string Info01 = "Place";
    private const string label = "<#0050FF> </color>{0:2}";
    private float m_frame;


    void Start()
    {

    }

    void Update()
    {
        //Counter.SetText(label, m_frame % 1000);
        // m_frame = S_Manager.Timer;

        /*
                if (S_Manager.Started == true)
                {
                    TextPhrase.SetText("Draw a " + S_Voice.word + " with your body!");
                    AC.SetTrigger("Launch");
                    AC.SetBool("PlayPhrase", true);
                }
                if (S_Manager.State == 1)
                {
                    TextSession.SetText("Place the shape");
                }
                else if (S_Manager.State == 2)
                {
                    TextSession.SetText("Compose with the second shape");
                    //  AC.SetTrigger("NextSession");
                }
                else if (S_Manager.State == 3)
                {
                    TextSession.SetText("Compose");
                    //  AC.SetTrigger("NextSession");
                }
                else if (S_Manager.State == 4)
                {
                    TextSession.SetText("Compose with the last shape");
                    // AC.SetTrigger("NextSession");
                }
                else if (S_Manager.State == 5)
                {
                    TextSession.SetText("IT'S FINISH");
                    //m_frame += 1 * Time.deltaTime;
                }
        */
    }
    public void ConsigneOnGame()
    {
        AC_Text.SetTrigger("SetConsigne");
        T_Consigne.SetText("Draw a " + S_Voice.word + " with your body!");
        AC_Text.GetBool("GameIsRunning");
        AC_Text.SetBool("GameIsRunning", true);
    }

    public void InfoJ1()
    {
        if (Manager.Round == 1)
        {
            T_J1.SetText("J1 use your body to create");
        }
        else if (Manager.Round == 2)
        {
            T_J1.SetText("J1 it's your turn !");
        }
        else if (Manager.Round == 3)
        {
            T_J1.SetText("J1...");
        }
        else if (Manager.Round == 4)
        {
            T_J1.SetText("J1 it's your last shape!");
        }

        AC_Text.SetTrigger("ApparitionTextJ1");
    }
    public void InfoJ2()
    {
        if (Manager.Round == 1)
        {
            T_J2.SetText("J2 Compose with the shape");
        }
        else if (Manager.Round == 2)
        {
            T_J2.SetText("Assemble les formes");
        }
        else if (Manager.Round == 3)
        {
            T_J2.SetText("J2!");
        }
        else if (Manager.Round == 4)
        {
            T_J2.SetText("Compose with the last shape!");
        }

        AC_Text.SetTrigger("ApparitionTextJ2");
    }

    public void Round()
    {
        if (Manager.Round == 1)
        {
            T_Counter.SetText("I");
        }
        else if (Manager.Round == 2)
        {
            T_Counter.SetText("I l");
        }
        else if (Manager.Round == 3)
        {
            T_Counter.SetText("I l I");
        }
        AC_Text.SetTrigger("SetCounter");
    }

    public void TextEndGame()
    {
        AC_Text.GetBool("GameIsRunning");
        AC_Text.SetBool("GameIsRunning", false) ;
    }


}