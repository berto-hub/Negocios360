import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Flutter Auth test", () {
    final email = find.byValueKey("email");
    final password = find.byValueKey("password");
    final signInButton = find.text("Iniciar sesión");
    final snackbar = find.byType("SnackBar");

    final profile = find.text("Perfil");
    final myProfile = find.byType("ProfilePage");
    
    final drawerWall = find.text("Muro");
    final wall = find.byType("HomePage");

    final drawerTeams = find.text("Mis equipos");
    final teams = find.byType("TeamsPage");

    final tapTeam = find.text("winTeam");
    final team = find.byType("TeamPage");

    final tapOtherProfile = find.text("Maria");
    final otherProfile = find.byType("OtherProfilePage");
    
    final drawerOffers = find.text("Mis ofertas");
    final offers = find.byType("OfferPage");

    final tapOffer = find.text("Ingeniero");
    final offer = find.byType("DetailOfferPage");

    final drawerOpportunities = find.text("Mis oportunidades");
    final opportunities = find.byType("OpportunitiesPage");

    final tapOpportunity = find.text("ro");
    final opportunity = find.byType("DetailOpporPage");
    
    final tapSendedOpportunities = find.text("Enviados");
    final sendedOpportunities = find.byType("SendedOpporPage");
    
    final drawerSearchUsers = find.text("Buscar usuarios");
    final searchUsers = find.byType("UserSearchPage");
    
    final drawerConversations = find.text("Mensajes");
    final conversations = find.byType("ChatPage");

    final tapChat = find.text("Maria");
    final chat = find.byType("MessagePage");

    final inputChat = find.byValueKey("message");
    final buttonSendMess = find.byValueKey("sendMessage");
    final newMess = find.text("hello");
    
    final buttonDrawer = find.byTooltip('Open navigation menu');
    final backButton = find.byValueKey("Back");
    final drawerSignOut = find.text("Cerrar sesión");
    final signOut = find.byType("SignInPage");

    final buttonCreateOffer = find.text("Crear oferta");
    final createOffer = find.byType("CreateOfferPage");
    final teamCreateOffer = find.byValueKey("team");
    final teamName = find.text("winTeam");
    final title = find.byValueKey("title");
    final description = find.byValueKey("description");
    final reward = find.byValueKey("reward");
    final typeReward = find.byValueKey("typeReward");
    final publicWall = find.byValueKey("public wall");
    final publicOfferButton = find.text("Publicar oferta");
    final snackbarCreateOffer = find.text(
      "Se ha creado la oferta Ingeniero"
    );

    final wallList = find.byValueKey("wallList");
    final buttonSendOpportunity = find.byValueKey("Ingeniero");
    final sendOpportunity = find.text("SecondPage");
    final nameContact = find.byValueKey("name");
    final telephoneContact = find.byValueKey("telephone");
    final emailContact = find.byValueKey("email");
    final sendOpportunityButton = find.text(
      "      Enviar\noportunidad"
    );
    final snackbarSendOpportunity = find.text(
      "Se ha recomendado el usuario Guillermo"
    );

    late FlutterDriver driver;
    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if(driver != null){
        driver.close();
      }
    });

    test("Login fail with incorrect email and password", () async {
      await driver.tap(email);
      await driver.enterText("dani@gmail.com");
      await driver.tap(password);
      await driver.enterText("hello");
      await driver.tap(signInButton);
      await driver.waitFor(snackbar);
      assert(snackbar != null);
      await driver.waitUntilNoTransientCallbacks();
      assert(wall == null);
    });

    test("Login with correct email and password", () async {
      await driver.tap(email);
      await driver.enterText("dani@gmail.com");
      await driver.tap(password);
      await driver.enterText("hello123");
      await driver.tap(signInButton);
      await driver.waitFor(snackbar);
      assert(snackbar != null);
      await driver.waitUntilNoTransientCallbacks();
      await driver.waitFor(wall);
      assert(wall != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Profile", () async {
      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(profile);
      await driver.tap(profile);
      await driver.waitFor(myProfile);
      assert(myProfile != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Create new Offer", () async {
      await driver.waitFor(buttonCreateOffer);
      await driver.tap(buttonCreateOffer);
      await driver.waitFor(createOffer);
      assert(createOffer != null);
      await driver.tap(teamCreateOffer);
      await driver.waitFor(teamName);
      await driver.tap(teamName);
      await driver.waitFor(title);
      await driver.tap(title);
      await driver.enterText("Ingeniero");
      await driver.tap(description);
      await driver.enterText(
        "Requerimos ingeniero debido a un proyecto que se desea " +
        "desarrollar."
      );
      await driver.tap(reward);
      await driver.enterText("1000");
      await driver.tap(typeReward);
      await driver.enterText("€");
      await driver.tap(publicWall);
      await driver.waitFor(publicOfferButton);
      await driver.tap(publicOfferButton);
      await driver.waitFor(snackbarCreateOffer);
      assert(snackbarCreateOffer != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Wall", () async {
      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerWall);
      await driver.tap(drawerWall);
      await driver.waitFor(wall);
      assert(wall != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Create new Opportunity", () async {
      await driver.scrollUntilVisible(
        wallList, buttonSendOpportunity
      );
      await driver.waitFor(buttonSendOpportunity);
      await driver.tap(buttonSendOpportunity);
      
      await driver.tap(nameContact);
      await driver.enterText("Guillermo");
      await driver.tap(telephoneContact);
      await driver.enterText("787277129");
      await driver.tap(emailContact);
      await driver.enterText("guille@gmail.com");
      await driver.waitFor(sendOpportunityButton);
      await driver.tap(sendOpportunityButton);
      await driver.waitFor(snackbarSendOpportunity);
      assert(snackbarSendOpportunity != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to My Teams", () async {
      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerTeams);
      await driver.tap(drawerTeams);
      await driver.waitFor(teams);
      assert(teams != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Team", () async {
      await driver.waitFor(tapTeam);
      await driver.tap(tapTeam);
      await driver.waitFor(team);
      assert(team != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Other Profile", () async {
      await driver.waitFor(tapOtherProfile);
      await driver.tap(tapOtherProfile);
      await driver.waitFor(otherProfile);
      assert(otherProfile != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to My Offers", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerOffers);
      await driver.tap(drawerOffers);
      await driver.waitFor(offers);
      assert(offers != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Offer Detail", () async {
      await driver.waitFor(tapOffer);
      await driver.tap(tapOffer);
      await driver.waitFor(offer);
      assert(offer != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to My Opportunities", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerOpportunities);
      await driver.tap(drawerOpportunities);
      await driver.waitFor(opportunities);
      assert(opportunities != null);
      await driver.waitUntilNoTransientCallbacks();
    },
    timeout: const Timeout(Duration(seconds: 40)),
    );

    test("Go to Opportunity Detail", () async {
      await driver.waitFor(tapOpportunity);
      await driver.tap(tapOpportunity);
      await driver.waitFor(opportunity);
      assert(opportunity != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Sended Opportunities", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(tapSendedOpportunities);
      await driver.tap(tapSendedOpportunities);
      await driver.waitFor(sendedOpportunities);
      assert(sendedOpportunities != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Search Users", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerSearchUsers);
      await driver.tap(drawerSearchUsers);
      await driver.waitFor(searchUsers);
      assert(searchUsers != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Other Profile", () async {
      await driver.waitFor(tapOtherProfile);
      await driver.tap(tapOtherProfile);
      await driver.waitFor(otherProfile);
      assert(otherProfile != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Conversations", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerConversations);
      await driver.tap(drawerConversations);
      await driver.waitFor(conversations);
      assert(conversations != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Go to Chat", () async {
      await driver.waitFor(tapChat);
      await driver.tap(tapChat);
      await driver.waitFor(chat);
      assert(chat != null);
      await driver.waitUntilNoTransientCallbacks();
    });

    test("Send Message", () async {
      await driver.tap(inputChat);
      await driver.enterText("hello");
      await driver.waitFor(buttonSendMess);
      await driver.tap(buttonSendMess);
      await driver.waitFor(newMess);
      assert(newMess != null);
      await driver.waitUntilNoTransientCallbacks();
    });
    
    test("Go to Sign Out", () async {
      await driver.waitFor(backButton);
      await driver.tap(backButton);

      await driver.waitFor(buttonDrawer);
      await driver.tap(buttonDrawer);
      await driver.waitFor(drawerSignOut);
      await driver.tap(drawerSignOut);
      await driver.waitFor(signOut);
      assert(signOut != null);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}