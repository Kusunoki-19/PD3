using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

public class ObjectDisplayControl : MonoBehaviour
{
    public int RECEIVE_PORT = 25000;
    public string SEND_HOST = "127.0.0.1";
    public int SEND_PORT = 25001;
    static UdpClient udp;
    int receiveData = 0;
    GameObject ball;
    GameObject stick;


    private Animator animator;

	// Use this for initialization
	void Start () {
        udp = new UdpClient(RECEIVE_PORT);
        udp.Client.ReceiveTimeout = 1000;


        ball = GameObject.Find("Sphere");
        stick = GameObject.Find("Cylinder");
        ball.SetActive(false);
        stick.SetActive(false);
	}
	
	// Update is called once per frame
    void Update()
    {
        IPEndPoint remoteEP = null;
        byte[] data = udp.Receive(ref remoteEP);
        //receiveData = BitConverter.ToInt32(data, 0);
        //Debug.Log(data);
        //Debug.Log(data[0]);
        switch (data[0])
        {
            case 1:
                ball.SetActive(true);
                stick.SetActive(false);
                break;
            case 2:
                ball.SetActive(false);
                stick.SetActive(true);
                break;
            default:
                ball.SetActive(false);
                stick.SetActive(false);
                break;
        }
	}
}
