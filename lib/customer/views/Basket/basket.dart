import 'package:flutter/material.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/views/Basket/pages_controlles.dart';
import 'package:harvest/customer/views/Basket/stepper.dart';
import 'package:harvest/customer/views/Basket/steps/basket_step.dart';
import 'package:harvest/customer/views/Basket/steps/billing_step.dart';
import 'package:harvest/customer/views/Basket/steps/delivery_time_step.dart';
import 'package:harvest/customer/views/Basket/steps/places_step.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/helpers/colors.dart';

enum _BasketSteps { Basket, Place, Delivery_Time, Billing }

class Basket extends StatefulWidget {
  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  ValueNotifier<int> _pagesNotifiew = ValueNotifier<int>(0);
  int _step = 0;

  @override
  void dispose() {
    _pagesNotifiew?.dispose();
    super.dispose();
  }

  Map<Widget, bool> _stepsAdv;

  @override
  void initState() {
    _stepsAdv = {
      BasketStep(
        onContinuePressed: () {
          setState(() {
            _step = 1;
          });
          return _jumpTo();
        },
      ): true,
      PlaceStep(
        onTapContinue: () {
          setState(() {
            _step = 2;
          });
          return _jumpTo();
        },
      ): false,
      DeliveryTimeStep(): false,
      BillingStep(): false,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(
        hideActions: true,
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [Container()],
        leading: CBackButton(
          onTap: () async {
            await _clearStepsVisiablity();
            Navigator.maybePop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: _pagesNotifiew,
                  builder: (context, value, child) => child,
                  child: Container(
                    // color: Colors.teal,
                    child: BasketStepper(
                      currentStep: _step,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _pagesNotifiew.value.round(),
                  children: _stepsAdv.keys.map((step) {
                    final _isVisible = _stepsAdv[step];
                    return Visibility(
                      visible: _isVisible,
                      child: step,
                    );
                  }).toList(),
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _pagesNotifiew,
                builder: (context, index, child) {
                  final _BasketSteps _currentStep = _getCurrentStep(index);
                  if (_currentStep == _BasketSteps.Basket) return SizedBox();
                  return BasketPagesControlles(
                    enableContinue: index != 1,
                    onContinuePressed: () {
                      setState(() {
                        if (index != 3) {
                          _step++;
                        }
                      });
                      return _jumpTo();
                    },
                    onPrevPressed: () {
                      setState(() {
                        if (index != 0) {
                          _step--;
                        }
                      });
                      return _jumpTo(index - 1);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _BasketSteps _getCurrentStep(int index) => _BasketSteps.values[index];

  ///`toIndex` has a default value which is the current index value + 1
  void _jumpTo([int toIndex]) {
    final _value = _pagesNotifiew.value;
    if (toIndex == null) toIndex = _value + 1;
    if (toIndex > _stepsAdv.length - 1) return;
    if (_value < toIndex) {
      final _nextKey = _stepsAdv.entries.toList()[toIndex].key;
      _stepsAdv[_nextKey] = true;
    }
    return setState(() => _pagesNotifiew.value = toIndex);
  }

  Future<void> _clearStepsVisiablity() {
    bool _skippedFirst = false;
    _stepsAdv.forEach((key, _) {
      if (_skippedFirst) {
        _stepsAdv[key] = false;
      } else {
        _skippedFirst = true;
      }
    });
    return Future<void>.value();
  }
}
