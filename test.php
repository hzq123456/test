<?php
/**
 * @author Hanzq
 * @datetime 2017-12-18 16:04
 */

$a= '343.12321';
echo sprintf("%.2f", strval($a) *100 ). 'ns';

//$url = "http://www.detection.com/#/";
//echo  "<img src='http://pan.baidu.com/share/qrcode?w=150&h=150&url=http://www.detection.com/#/'>";
////function gen() {
//    yield 'foo';
//    yield 'bar';
//}
//
//$gen = gen();
//var_dump($gen->send('something'));

//
//function a(string $id){
//
//    var_dump(is_numeric($id));
//}
//a(1);
//
//function gen(){
//    $ret = (yield 'yield1');
//    var_dump($ret);
//    $ret = (yield 'yield2');
//    var_dump($ret);
//}
//
//$gen = gen();
//var_dump($gen->current());    // string(6) "yield1"
//var_dump($gen->send('ret1')); // string(4) "ret1"   (the first var_dump in gen)
//// string(6) "yield2" (the var_dump of the ->send() return value)
//var_dump($gen->send('ret2'));







//function logger($fileName) {
//    $fileHandle = fopen($fileName, 'a');
//    while (true) {
//        fwrite($fileHandle, yield . "\n");
//    }
//}
//
//$logger = logger(__DIR__ . '/log');
//$logger->send('Foo');
//$logger->send('Bar');







//function xrange($start, $limit, $step = 1) {
//    if ($start < $limit) {
//        if ($step <= 0) {
//            throw new LogicException('Step must be +ve');
//        }
//
//        for ($i = $start; $i <= $limit; $i += $step) {
//            yield $i;
//        }
//    } else {
//        if ($step >= 0) {
//            throw new LogicException('Step must be -ve');
//        }
//
//        for ($i = $start; $i >= $limit; $i += $step) {
//            yield $i;
//        }
//    }
//}
//
//echo memory_get_usage(), '<br />'; // 377952
//
//$a = xrange(1,1000000,1);
//
//echo memory_get_usage(); // 382304
//
//echo memory_get_usage(), '<br />'; // 376264
//
//$a = range(1,1000000,1);
//
//echo memory_get_usage(); // 27639304




//echo <<<EOF
//<script>alert(1)</script>;
//EOF;
//echo
//<<<STR
//"ssda;'
//STR;

//$data = [['a'=>'test'],['b'=>'bob']];
//foreach ($data as $key =>&$v){
//       $v['ss']= 'ok';
//}
//
//var_dump($data);

//$a = [1];
//$a[] = &$a;
//
//print_r($a);