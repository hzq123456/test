<?php
/**
 * SPL妙用
 *
 * @author Hanzq
 * @datetime 2017-12-29 15:39
 */




/**  -----------       四 、读取大文件最后几行    ------------     **/

function tail($fp, $n, $base = 5)
{
    assert($n > 0);
    $pos = $n + 1;
    $lines = array();
    while (count($lines) <= $n)
    {
        try
        {
            fseek($fp, -$pos, SEEK_END);
        }
        catch (Exception $e)
        {
            fseek(0);
            break;
        }
        $pos *= $base;
        while (!feof($fp))
        {
            array_unshift($lines, fgets($fp));
        }
    }

    return array_slice($lines, 0, $n);
}

var_dump(tail(fopen("error.log", "r+"), 10));









/**  -----------       三 、查找指定行    ------------     **/

//try {
//    $file = new SplFileObject('data.csv');
//    var_dump($file->getCurrentLine());
//    $file->seek(0);
//    echo $file->current();
//} catch (Exception $e) {
//    echo $e->getMessage();
//}


/**  -----------       二 、读文件    ------------     **/

//$file = new SplFileInfo('data.csv');
//
//
//try {
//    foreach(new SplFileObject('data.csv') as $line) {
//        echo $line;
//    }
//} catch (Exception $e) {
//    echo $e->getMessage();
//}

/**  -----------       一 、写csv文件    ------------     **/

/*$lists = [
    ['aa','bb','cc'], ['111','2222','333'], ['cat','dog']
];
$file = new SplFileObject('data.csv','w');

foreach ($lists as $list){
    $file->fputcsv($list);
}*/