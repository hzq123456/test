<?php

/**
 * @author Hanzq
 * @datetime 2017-12-18 16:07
 */

// 主题接口
interface Subject
{
    public function register(Observe $observe);

    public function notify();

}

// 观察者接口
interface Observe
{
    public function watch();
}

//主题
class Action implements Subject{
    public $_observers = array();

    public function register(Observe $observe)
    {
        $this->_observers[] = $observe;
    }

    public function notify()
    {
        foreach ($this->_observers as $observer){
            $observer->watch();
        }
    }
}

class Cat implements Observe{
    public function watch()
    {
        echo "Cat watches TV<hr/>";
    }
}

class Dog implements Observe{
    public function watch(){
        echo "Dog watches TV<hr/>";
    }
}

class People implements Observe{
    public function watch(){
        echo "People watches TV<hr/>";
    }
}

$action = new Action();
$action->register(new Cat());
$action->register(new Dog());
$action->register(new People());
$action->notify();


