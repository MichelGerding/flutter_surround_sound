import 'dart:math' as Math;

class AngleConverter {
  Map<num, Map<String, num>> _angleLookup = {
    0: {'x': 1, 'y': 0},
    45: {'x': 1, 'y': 1},
    90: {'x': 0, 'y': 1},
    135: {'x': -1, 'y': 1},
    180: {'x': -1, 'y': 0},
    225: {'x': -1, 'y': -1},
    270: {'x': 0, 'y': -1},
    315: {'x': -1, 'y': 1},
    360: {'x': 1, 'y': 0},
  };

  /// parse the angle to a valid angle by converting it into a
  /// range between 0 and 360
  num createValidAngle(num angle) {
    return (angle % 360) + angle;
  }

  /// convert a angle into coordinates with a single coord always on the edge of
  /// the coordinates grid. this function returns a map with a x and a y
  Map<String, num> angleToCoords(num angle) {
    Map<String, num> coords = {'x': 0.0, 'y': 0.0};
    if (_angleLookup.containsKey(angle)) {
      // check if angle has been calculated before.
      return _angleLookup[angle] ?? coords;
    }

    angle = createValidAngle(angle);

    // convert the angle to coordinates
    num aLen = angleToLongestAxisLength(angle % 45);
    if (angle < 45) {
      coords['y'] = 1;
      coords['x'] = aLen;
    } else if (angle < 135) {
      if ((angle / 90).floor() == 0) {
        coords['y'] = 1 - aLen;
      } else {
        coords['y'] = aLen * -1;
      }
      coords['x'] = 1;
    } else if (angle < 225) {
      coords['y'] = -1;
      if ((angle / 90).floor() == 1) {
        coords['x'] = 1 - aLen;
      } else {
        coords['x'] = aLen * -1;
      }
    } else if (angle < 315) {
      coords['x'] = -1;
      if ((angle / 90).floor() == 2) {
        coords['y'] = -1 + aLen;
      } else {
        coords['y'] = aLen;
      }
    } else if (angle < 360) {
      coords['y'] = 1;
      coords['x'] = -1 + aLen;
    }

    _angleLookup.putIfAbsent(angle, () => coords);

    return coords;
  }

  /// get the longest sides length
  num angleToLongestAxisLength(num angleInDegrees) {
    num sinA = Math.sin(degToRad(angleInDegrees));
    num sinB = Math.sin(degToRad(90 - angleInDegrees));

    return sinA / sinB;
  }

  /// convert the a angle into radians
  num degToRad(num degrees) {
    return degrees / 180 * Math.pi;
  }
}
