<?php

/**
 * 策略模式
 *
 * Interface Math
 *
 * @author hanzq
 */
interface Math
{
    public function calc($op1, $op2);
}

class MathAdd implements Math
{

    public function calc($op1, $op2)
    {
        return $op1 + $op2;
    }
}

class MathSub implements Math
{
    public function calc($op1, $op2)
    {
        return $op1 - $op2;
    }
}

class MathMul implements Math
{
    public function calc($op1, $op2)
    {
        return $op1 * $op2;
    }
}

class MathDiv implements Math
{
    public function calc($op1, $op2)
    {
        return $op1 / $op2;
    }
}


class computer
{
    private $math = null;

    public function __construct($math)
    {
        $classMath = 'Math' . $math;
        $this->math = new $classMath;
    }

    public function getResult($op1, $op2)
    {
        return $this->math->calc($op1, $op2);
    }
}

$test = new computer('Div');
$res = $test->getResult(1, 3);
var_dump($res);

