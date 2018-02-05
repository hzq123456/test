<?php

/**
 * @author Hanzq
 * @datetime 2018-01-24 14:12
 */
class manuDI implements ArrayAccess
{
    /**
     * 单例
     * @var
     */
    protected static $instance;

    /**
     * 容器所管理的实例
     * @var array
     */
    protected $instances = [];

    private function __construct()
    {

    }


    private function __clone()
    {
        // TODO: Implement __clone() method.
    }

    /**
     * 获取单例的实例
     */
    public function singleton($class, $params)
    {
        if(isset($this->instances[$class])){
            return $this->instances[$class];
        }else{
            $this->instances[$class] =$this->make($class,$params);
        }
            return $this->instances[$class];

    }

    /**
     * 获取实例（每次都会创建一个新的）

     */
    public function get($class, ...$params)
    {
        return $this->make($class,$params);
    }

    /**
     * 工厂方法，创建实例，并完成依赖注入
     */
    public function make($class, $params = [])
    {
        //如果不是反射类根据类名创建
        $class = is_string($class)? new ReflectionClass($class):$class;

        //如果传入的参数不为空，根据传入参数创建实例
        if(!empty($params)){
            return $class->newInstanceArgs($params);
        }

        //获取构造方法
        $construct = $class->getConstructor();

        //获取构造方法参数
        $parameterClasses = $construct ? $construct->getParameters() : [];

        if(empty($parameterClasses)){
            //如果构建方法没有注入参数，直接创建
            return $class->newInstance();
        }else{
            //如果构建方法有注入参数，迭代并递归创建依赖实例
            foreach ($parameterClasses as $parameterClass){
                $parameterClass = $parameterClass->getClass();
                $params[] = $this->make($parameterClass);
            }

            return$class->newInstanceArgs($params);
        }

    }

    public static function getInstance()
    {

        if (null === static::$instance) {
            static::$instance = new static();
        }

        return static::$instance;
    }

    public function __get($class)
    {
       if(!isset($this->instances[$class])){
           $this->instances[$class] = $this->make($class);
       }

       return  $this->instances[$class];
    }

    public function offsetExists($offset){
        return isset($this->instances[$offset]);
    }

    public function offsetGet($offset)
    {
        if (!isset($this->instances[$offset])) {
            $this->instances[$offset] = $this->make($offset);
        }
        return $this->instances[$offset];
    }

    public function offsetSet($offset,$value)
    {

    }

    public function offsetUnset($offset)
    {
        unset($this->instances[$offset]);
    }

}





class Driver
{
    public function drive()
    {
        $car = new Car();
        echo '老司机正在驾驶', $car->getCar(), PHP_EOL;
    }
}

class Car
{
    protected $name = '普通汽车';

    public function getCar()
    {
        return $this->name;
    }
}

class Benz extends Car
{
    protected $name = '奔驰';
}


$ref = new ReflectionClass(manuDI::class);
var_dump($ref->getMethods());
//$benz = $app->get(Benz::class);
//
//$driver = $app->get(Driver::class,$benz);
//
//$driver->drive();



