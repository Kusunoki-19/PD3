using System.Collections;
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

    int receiveData = 0;

    private Animator animator;


	// Use this for initialization
	void Start () {
        receiver = new UdpClient(RECEIVE_PORT);
        receiver.Client.ReceiveTimeout = 1000;

        animator = GetComponent<Animator>();
        animator.SetBool("Gripping", false);
        animator.SetBool("Picking", false);
        animator.SetBool("Relaxing", false);
	}
	
	// Update is called once per frame
    void Update()
    {
        IPEndPoint remoteEP = null;
        byte[] data = receiver.Receive(ref remoteEP);
        
        //Debug.Log("data ToStr : " + BitConverter.ToString(data));
        //Debug.Log("data lengt : " + data.Length);
        receiveData = int.Parse(BitConverter.ToString(data));
        //Debug.Log("data ToInt : " + receiveData);

        switch (receiveData)
        {
            case 0:
                animator.SetBool("Relaxing", true);
                animator.SetBool("Gripping", false);
                animator.SetBool("Picking", false);
                break;
            case 1:
                animator.SetBool("Relaxing", false);
                animator.SetBool("Gripping", true);
                animator.SetBool("Picking", false);
                break;
            case 2:
                animator.SetBool("Relaxing", false);
                animator.SetBool("Gripping", false);
                animator.SetBool("Picking", true);
                break;
            default:
                animator.SetBool("Relaxing", true);
                animator.SetBool("Gripping", false);
                animator.SetBool("Picking", false);
                break;
        }
	}
}
