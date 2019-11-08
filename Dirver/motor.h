#ifndef _MOTOR_H_
#define _MOTOR_H_

#include<stdio.h>
#include<stdbool.h>
typedef struct
{
	int motorSpeed;
	bool motorDir;
}MotorDev_t;

extern MotorDev_t MOTOR;

void motor_init(void);
//test comment
void motor_setSpeed(int speed);

void motor_stop(void);

void motor_showSpeed(void);

#endif //#ifndef _MOTOR_H_


