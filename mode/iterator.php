<?php

/**
 * 迭代器模式
 *
 * @author Hanzq
 * @datetime 2017-12-18 17:16
 */

class AllUser implements \Iterator
{
    protected $index = 0;
    protected $data = [];

    public function __construct()
    {
        $link = mysqli_connect('192.168.0.91', 'root', '123', 'xxx');
        $rec = mysqli_query($link, 'select id from doc_admin');
        $this->data = mysqli_fetch_all($rec, MYSQLI_ASSOC);
    }

    //1 重置迭代器
    public function rewind()
    {
        $this->index = 0;
    }

    //2 验证迭代器是否有数据
    public function valid()
    {
        return $this->index < count($this->data);
    }

    //3 获取当前内容
    public function current()
    {
        $id = $this->data[$this->index];
        return User::find($id);
    }

    //4 移动key到下一个
    public function next()
    {
        return $this->index++;
    }


    //5 迭代器位置key
    public function key()
    {
        return $this->index;
    }
}

//实现迭代遍历用户表
$users = new AllUser();
//可实时修改
foreach ($users as $user){
    $user->add_time = time();
    $user->save();
}



/**------------------------------------------------------------------------**/

//抽象迭代器
abstract class IIterator
{
    public abstract function First();

    public abstract function Next();

    public abstract function IsDone();

    public abstract function CurrentItem();
}

//具体迭代器
class ConcreteIterator extends IIterator
{
    private $aggre;
    private $current = 0;

    public function __construct(array $_aggre)
    {
        $this->aggre = $_aggre;
    }

    public function First()
    {
        return $this->aggre[0];
    }

    public function Next()
    {
        $this->current++;
        if($this->current<count($this->aggre)){
            return $this->aggre[$this->current];
        }
        return false;
    }

    public function IsDone()
    {
        return $this->current>=count($this->aggre)?true:false;
    }

    public function CurrentItem()
    {
        return $this->aggre[$this->current];
    }
}

$iterator = new ConcreteIterator(['周杰伦','王菲','周润发']);
$item = $iterator->First();
echo  $item."<br/>";
while (!$iterator->IsDone()){
    echo "{$iterator->CurrentItem()}：请买票！<br/>";
    $iterator->Next();
}



