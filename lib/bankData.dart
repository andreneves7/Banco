class Bank {
  final String id;
  final String logoUrl;
  final String name;
  final String aspspCode;

  Bank({this.name, this.aspspCode, this.id, this.logoUrl});
}

/*var bankList = [
  Bank(
      name: "BANCO ACTIVOBANK, SA",
      aspspCode: "ABPT",
      id: "414354565054504C585858",
      logoUrl:
          "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/ActivoBank-1.png")
];*/

var bankList = [
  {
    "id": "414354565054504C585858",
    "bic": "ACTVPTPLXXX",
    "bank-code": "0023",
    "aspsp-cde": "ABPT",
    "name": "BANCO ACTIVOBANK, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/ActivoBank-1.png"
  },
  {
    "id": "42434F4D5054504C",
    "bic": "BCOMPTPL",
    "bank-code": "0033",
    "aspsp-cde": "BCPPT",
    "name": "BANCO COMERCIAL PORTUGUES, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Millenium-bcp-1.png"
  },
  {
    "id": "544F54415054504C",
    "bic": "TOTAPTPL",
    "bank-code": "0018",
    "aspsp-cde": "BST",
    "name": "BANCO SANTANDER TOTTA, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Santander-1.png"
  },
  {
    "id": "424250495054504C",
    "bic": "BBPIPTPL",
    "bank-code": "0010",
    "aspsp-cde": "BBPI",
    "name": "BANCO BPI, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/BPI-2.png"
  },
  {
    "id": "424B424B5054504C585858",
    "bic": "BKBKPTPLXXX",
    "bank-code": "0269",
    "aspsp-cde": "BNKI",
    "name": "BANKINTER, SA - SUCURSAL EM PORTUGAL",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Bankinter-1.png"
  },
  {
    "id": "4D50494F5054504C585858",
    "bic": "MPIOPTPLXXX",
    "bank-code": "0036",
    "aspsp-cde": "CEMG",
    "name": "CAIXA ECONOMICA MONTEPIO GERAL",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/montepio-1.png"
  },
  {
    "id": "4343434D5054504C",
    "bic": "CCCMPTPL",
    "bank-code": "0045",
    "aspsp-cde": "GCA",
    "name": "CAIXA CENTRAL - CAIXA CENTRAL DE CREDITO AGRICOLA MUTUO, CRL",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/CCCAM-2.png"
  },
  {
    "id": "43454D4150545032585858",
    "bic": "CEMAPTP2XXX",
    "bank-code": "0059",
    "aspsp-cde": "CEMAH",
    "name": "CAIXA ECONOMICA DA MISERICORDIA DE ANGRA DO HEROISMO",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/CEMAH-logo.png"
  },
  {
    "id": "424150415054504C585858",
    "bic": "BAPAPTPLXXX",
    "bank-code": "0189",
    "aspsp-cde": "ATLEU",
    "name": "BANCO ATLANTICO EUROPA, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Atlantico-1.png"
  },
  {
    "id": "435454565054504C585858",
    "bic": "CTTVPTPLXXX",
    "bank-code": "0193",
    "aspsp-cde": "BCTT",
    "name": "BANCO CTT, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/BancoCTT-1.png"
  },
  {
    "id": "424449475054504C585858",
    "bic": "BDIGPTPLXXX",
    "bank-code": "0061",
    "aspsp-cde": "BIG",
    "name": "BANCO DE INVESTIMENTO GLOBAL, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Big-1.png"
  },
  {
    "id": "425047505054504C585858",
    "bic": "BPGPPTPLXXX",
    "bank-code": "0064",
    "aspsp-cde": "BPG",
    "name": "BANCO PORTUGUES DE GESTAO, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/BPG-1.png"
  },
  {
    "id": "4344435450545032585858",
    "bic": "CDCTPTP2XXX",
    "bank-code": "5180",
    "aspsp-cde": "CCAML",
    "name": "CAIXA DE CREDITO AGRICOLA MUTUO DE LEIRIA, CRL",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Caixa-Crédito-Leiria-1.png"
  },
  {
    "id": "42504E505054504C585858",
    "bic": "BPNPPTPLXXX",
    "bank-code": "0079",
    "aspsp-cde": "BIC",
    "name": "BANCO BIC PORTUGUES, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/EuroBic-2.png"
  },
  {
    "id": "434744495054504C",
    "bic": "CGDIPTPL",
    "bank-code": "0035",
    "aspsp-cde": "CGDPT",
    "name": "CAIXA GERAL DE DEPOSITOS, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/CGD-2.png"
  },
  {
    "id": "4347444946525050585858",
    "bic": "CGDIFRPPXXX",
    "bank-code": "8226",
    "aspsp-cde": "CGDFR",
    "name": "CAIXA GERAL DE DEPOSITOS FRANCE",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Caixa-Geral-de-Depósitos-France-1.png"
  },
  {
    "id": "424553435054504C",
    "bic": "BESCPTPL",
    "bank-code": "0007",
    "aspsp-cde": "NVB",
    "name": "NOVO BANCO, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Novo-Banco-2.png"
  },
  {
    "id": "4245534150545041585858",
    "bic": "BESAPTPAXXX",
    "bank-code": "0160",
    "aspsp-cde": "NVBA",
    "name": "NOVO BANCO DOS ACORES, SA",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/02/Novo-Banco-dos-Açores-1.png"
  },
  {
    "id": "4346464950545031585858",
    "bic": "CFFIPTP1XXX",
    "bank-code": "0921",
    "aspsp-cde": "COF",
    "name": "COFIDIS",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/04/cofidis_sibs_api_cinza.png"
  },
  {
    "id": "43444F5450545031585858",
    "bic": "CDOTPTP1XXX",
    "bank-code": "5200",
    "aspsp-cde": "CAMAF",
    "name": "Caixa De Credito Agricola Mutuo De Mafra, C.R.L. ",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/07/2.png"
  },
  {
    "id": "4343434850545031585858",
    "bic": "CCCHPTP1XXX",
    "bank-code": "0097",
    "aspsp-cde": "CACHM",
    "name": "Caixa De Credito Agricola Mutuo Da Chamusca, C.r.l",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/07/CACHM.png"
  },
  {
    "id": "4345525450545031585858",
    "bic": "CERTPTP1XXX",
    "bank-code": "0098",
    "aspsp-cde": "CABOM",
    "name": "Caixa De Credito Agricola Mutuo De Bombarral Crl",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/07/3-1.png"
  },
  {
    "id": "4354495550545031585858",
    "bic": "CTIUPTP1XXX",
    "bank-code": "5340",
    "aspsp-cde": "CATV",
    "name": "Caixa De Credito Agricola Mutuo De Torres Vedras,c.r.l",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/07/1.png"
  },
  {
    "id": "5549464350545031585858",
    "bic": "UIFCPTP1XXX",
    "bank-code": "0698",
    "aspsp-cde": "UNICR",
    "name": "Unicre - Instituição Financeira de Crédito S.A",
    "logoLocation":
        "https://sibs-productsites.azurewebsites.net/apimarket/wp-content/uploads/sites/17/2019/04/Logo-Unicre-ajustável-e1556288254677.png"
  }
];
