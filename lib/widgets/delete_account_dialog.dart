import 'package:flutter/material.dart';


class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 16, left: 76, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Are you sure to delete your account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: Colors.purpleAccent))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.purpleAccent,
                                  fontSize: 20,
                                ),
                              )),
                          SizedBox(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () {
                                Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).height * .365,
          left: 50,
          child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                  color: Colors.purpleAccent, shape: BoxShape.circle),
              child: Image.asset("assets/icons/trash.png")),
        ),
        Positioned(
          top:MediaQuery.sizeOf(context).height * .475,
          left: 35,
          child: Image.asset("assets/images/dialog_decoration.png"),
        ),
      ]),
    );
  }
}
