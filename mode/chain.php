<?php

/**
 * 责任链模式
 *
 * Class Handler
 *
 * @author hanzq
 */
abstract class Handler
{
    protected $higher = null;

    abstract public function operation($lev);
}

class bz extends Handler
{
    protected $higher = 'admin';

    public function operation($lev)
    {
        if ($lev <= 1) {
            echo '版主搞定';
        } else {
            $higher = new $this->higher;
            $this->higher = new $higher();
            $this->higher->operation($lev);
        }
    }
}

class admin extends Handler
{
    protected $higher = 'police';

    public function operation($lev)
    {
        if ($lev <= 2) {
            echo '管理员搞定';
        } else {
            $higher = new $this->higher;
            $this->higher = new $higher();
            $this->higher->operation($lev);
        }
    }
}

class police extends Handler
{
    protected $higher = 'police';

    public function operation($lev)
    {
        echo '警察搞定';
    }
}

$test = new bz();
$test->operation(3);

