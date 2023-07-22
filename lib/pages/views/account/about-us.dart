import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/contacts_launcher.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "About Us",
      subtitle: 'How it started',
      body: AboutUsContent(),
      layout: 2,
    );
  }
}

class AboutUsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const t = 0.2;
    const borderRadius = 10.0;

    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset("images/icons/logo.svg"),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 2,
                      width: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/companyLogoBlack.png"),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(app_brief_long, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GET IN TOUCH
            ListViewHeader(title: 'Contacts'),
            CustomListTile(
              t: t,
              title: "Phone Number",
              subtitle: company_number,
              icon: FluentIcons.call_24_filled,
              trailingIcon: FluentIcons.open_24_filled,
              bgColor: Colors.teal,
              iconColor: Colors.teal,
              borderRadius: borderRadius,
              onTap: () => launchContactNumber(company_number),
            ),
            CustomListTile(
              t: t,
              title: "Email",
              subtitle: company_feedback_email,
              icon: FluentIcons.mail_24_filled,
              trailingIcon: FluentIcons.open_24_filled,
              bgColor: Colors.orange,
              iconColor: Colors.orange,
              borderRadius: borderRadius,
              onTap: () => launchEmail(
                company_feedback_email,
                "Feedback on ProjectFlow",
              ),
            ),
            CustomListTile(
              t: t,
              title: "Company Website",
              subtitle: company_name,
              icon: FluentIcons.web_asset_24_filled,
              trailingIcon: FluentIcons.open_24_filled,
              bgColor: Colors.red,
              iconColor: Colors.red,
              borderRadius: borderRadius,
              onTap: () => launchURL(company_website),
            ),

            // CREDITS
            ListViewHeader(title: 'Team'),
            CustomListTile(
              t: t,
              title: "Developer",
              subtitle: company_developer,
              icon: FluentIcons.person_24_filled,
              bgColor: Colors.blueGrey,
              iconColor: Colors.blueGrey,
              borderRadius: borderRadius,
            ),
          ],
        ),
      ],
    );
  }
}
