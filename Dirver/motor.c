#include "motor.h"

MotorDev_t MOTOR;

void motor_init(void)
{
	MOTOR.motorSpeed = 0;
	MOTOR.motorDir = false;
}
void motor_setSpeed(int speed)
{
	MOTOR.motorSpeed = speed;
	printf("now Motor Speed was :%d\n",MOTOR.motorSpeed);
}

void motor_stop(void)
{
	MOTOR.motorSpeed = 0;
	printf("now Motor Stoped\n");
}
void motor_showSpeed(void)
{
	printf("now Motor Speed was :%d\n",MOTOR.motorSpeed);

}


