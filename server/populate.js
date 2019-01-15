const User = require('./api/users/user.model');
const connection = require("./config/mongoose");
connection();
const populateNumber=10;
const names=[
    "Kacper",
"Kaja",
"Kajetan",
"Kajetana",
"Kajmir",
"Kajus",
"Kalasanty",
"Kalikst",
"Kalista",
"Kalina",
"Kalinik",
"Kalistrat",
"Kalmir",
"Kamil",
"Kamila",
"Kancjan",
"Kancjanela",
"Kancjusz",
"Kandyd",
"Kandyda",
"Kanizjusz",
"Kanimir",
"Kanizja",
"Kanmił",
"Kanut",
"Kanuta",
"Kapitolina",
"Karina",
"Karol",
"Karola",
"Karolina",
"Karp",
"Karina",
 "Karyna",
"Kasandra",
"Kasjan",
"Kasjana",
"Kasjusz",
"Kasper",
"Kastor",
"Kasylda",
"Katarzyna",
"Kazimiera",
"Kazimierz",
"Kewin",
"Kiejstut",
"Kilian",
]
const surnames=[
    "Amsterdamski",
"Arab", "Arabik", "Arabowicz", "Arabski",
"Austrijak",
"Białoruski",
"Brandenburg", "Brandenburger",
"Cygan",
"Chorwat",
"Czech", "Czeski", "Böhm",
"Duńczyk",
"Francuz",
"Gal", "Galoch",
"Galicki", "Halicki",
"Góral", "Gorol",
"Hiszpan",
"Holender", "Holenderski", "Holland", "Olęder", "Olender",
"Kaszuba", "Kaszub",
"Kijowski",
"Kurlandt", "Kurlandzki", "Kurlanda", "Kurland", "Kurlandczyk",
"Kuruc",
"Kuman", "Koman",
"Litwin", "Litwiniuk", "Litwinowicz",
"Łotysz",
"Macedoński",
"Madziar", "Madziara",
"Mazur", "Mazurek", "Mazurkiewicz",
"Moraw", "Morawski",
"Niemiec", "Niemczyk",
"Norwecki",
"Petersburski",
"Podolak", "Podolski", "Podolec", "Podolan",
'Polak', "Polok", "Poloczek", "Polakowski", "Polaczek",
"Poleszak", "Polesiak", "Poleski", "Poleszczuk", "Poleszuk",
"Pomorski",
"Pruski", "Prus", "Prusak", "Prusek", "Prusik", "Pruś",
"Rosjan",
"Rus", "Rusin", "Rusek", "Rusak", "Rusnak",
"Rumun", "Rumuński", "Romun",
"Sakson",
"Sas", "Sasin", "Sass"
]

let pesels=[];
let list=[];
  for(let i=0;i<populateNumber;i++){
      let name=names[Math.floor(Math.random() * names.length)];
      let surname=surnames[Math.floor(Math.random() * surnames.length)];
        let pesel=makePesel();
      list.push(new User({
         name ,
         surname,
         pesel,
         email:`${pesel}@${name}.pl`,
         IDCardNumber:makeid(),
         age:Math.floor(Math.random() * 70),
         password:"test"
      }));

      
  }


User.create(list).then(
    ()=>{
        process.exit(-1);
    }
).catch((e)=>{
    console.log(e);
    process.exit(-1);
});



function makeid(possible= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",n=11) {
    text = "";
    possible ;
    for (var i = 0; i < n; i++)
      text += possible.charAt(Math.floor(Math.random() * possible.length));
  
    return text;
  }

  function makePesel(){
    let pesel='';
    do{
        pesel=makeid("0987654321");
    }while(pesels.indexOf(pesel)!=-1)
    pesels.push(pesel);
    return pesel;
    
  }
