class specialStr{
  static String  re(String str){
    var c=str;
    //* /：<>？\ | +，。; = []
    var special =[
    ["<", "＜"],
    [">", "＞"],
    ["\\", "＼"],
    ["/", "／"],
    [":", "："],
    ["?", "？"],
    ["*", "＊"],
    ["\"", "＂"],
    ["|", "｜"],
    [',','，'],
    [';','；'],
    ['=','＝'],
    ["...", " "]];


    return special.fold(str, (acc, e) => acc.replaceAll(e[0],e[1]));
  }
}