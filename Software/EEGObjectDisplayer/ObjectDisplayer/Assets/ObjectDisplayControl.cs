﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

public class ObjectDisplayControl : MonoBehaviour
{
    private UdpClient receiver;
    private int RECEIVE_PORT = 25000;
    private string SEND_HOST = "127.0.0.1";

    private UdpClient sender;
    private int SEND_PORT = 25001;
    int receiveData = 0;
    GameObject ball;
    GameObject stick;


    private Animator animator;

	// Use this for initialization
	void Start () {
        receiver = new UdpClient(RECEIVE_PORT);
        receiver.Client.ReceiveTimeout = 1000;

        sender = new UdpClient();
        sender.Connect(SEND_HOST, SEND_PORT);

        //object initialize. fetch object, and display none
        ball = GameObject.Find("Sphere");
        stick = GameObject.Find("Cylinder");
        ball.SetActive(false);
        stick.SetActive(false);
	}
	
	// Update is called once per frame
    void Update()
    {
        IPEndPoint remoteEP = null;
        byte[] data = receiver.Receive(ref remoteEP);
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
        sender.Send(data, data.Length);
	}
}
