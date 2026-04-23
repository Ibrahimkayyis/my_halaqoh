// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSummaryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummaryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardSummaryState()';
}


}

/// @nodoc
class $DashboardSummaryStateCopyWith<$Res>  {
$DashboardSummaryStateCopyWith(DashboardSummaryState _, $Res Function(DashboardSummaryState) __);
}


/// Adds pattern-matching-related methods to [DashboardSummaryState].
extension DashboardSummaryStatePatterns on DashboardSummaryState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( int attendedCount,  int totalSantriCount,  double attendancePercent,  int setoranCount,  double setoranPercent,  List<LatestSetoranItem> latestSetoran)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.attendedCount,_that.totalSantriCount,_that.attendancePercent,_that.setoranCount,_that.setoranPercent,_that.latestSetoran);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( int attendedCount,  int totalSantriCount,  double attendancePercent,  int setoranCount,  double setoranPercent,  List<LatestSetoranItem> latestSetoran)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.attendedCount,_that.totalSantriCount,_that.attendancePercent,_that.setoranCount,_that.setoranPercent,_that.latestSetoran);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( int attendedCount,  int totalSantriCount,  double attendancePercent,  int setoranCount,  double setoranPercent,  List<LatestSetoranItem> latestSetoran)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.attendedCount,_that.totalSantriCount,_that.attendancePercent,_that.setoranCount,_that.setoranPercent,_that.latestSetoran);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements DashboardSummaryState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardSummaryState.initial()';
}


}




/// @nodoc


class _Loading implements DashboardSummaryState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardSummaryState.loading()';
}


}




/// @nodoc


class _Loaded implements DashboardSummaryState {
  const _Loaded({required this.attendedCount, required this.totalSantriCount, required this.attendancePercent, required this.setoranCount, required this.setoranPercent, required final  List<LatestSetoranItem> latestSetoran}): _latestSetoran = latestSetoran;
  

// ── Attendance (latest session) ──
/// Number of santri marked 'hadir' in the latest session
 final  int attendedCount;
/// Total santri in the halaqoh
 final  int totalSantriCount;
/// Attendance percentage (0.0 – 1.0)
 final  double attendancePercent;
// ── Setoran ──
/// Distinct santri who submitted any hafalan today
 final  int setoranCount;
/// Setoran percentage (0.0 – 1.0)
 final  double setoranPercent;
// ── Latest Setoran list ──
/// 3 most recent setoran entries
 final  List<LatestSetoranItem> _latestSetoran;
// ── Latest Setoran list ──
/// 3 most recent setoran entries
 List<LatestSetoranItem> get latestSetoran {
  if (_latestSetoran is EqualUnmodifiableListView) return _latestSetoran;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_latestSetoran);
}


/// Create a copy of DashboardSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.attendedCount, attendedCount) || other.attendedCount == attendedCount)&&(identical(other.totalSantriCount, totalSantriCount) || other.totalSantriCount == totalSantriCount)&&(identical(other.attendancePercent, attendancePercent) || other.attendancePercent == attendancePercent)&&(identical(other.setoranCount, setoranCount) || other.setoranCount == setoranCount)&&(identical(other.setoranPercent, setoranPercent) || other.setoranPercent == setoranPercent)&&const DeepCollectionEquality().equals(other._latestSetoran, _latestSetoran));
}


@override
int get hashCode => Object.hash(runtimeType,attendedCount,totalSantriCount,attendancePercent,setoranCount,setoranPercent,const DeepCollectionEquality().hash(_latestSetoran));

@override
String toString() {
  return 'DashboardSummaryState.loaded(attendedCount: $attendedCount, totalSantriCount: $totalSantriCount, attendancePercent: $attendancePercent, setoranCount: $setoranCount, setoranPercent: $setoranPercent, latestSetoran: $latestSetoran)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $DashboardSummaryStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 int attendedCount, int totalSantriCount, double attendancePercent, int setoranCount, double setoranPercent, List<LatestSetoranItem> latestSetoran
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of DashboardSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attendedCount = null,Object? totalSantriCount = null,Object? attendancePercent = null,Object? setoranCount = null,Object? setoranPercent = null,Object? latestSetoran = null,}) {
  return _then(_Loaded(
attendedCount: null == attendedCount ? _self.attendedCount : attendedCount // ignore: cast_nullable_to_non_nullable
as int,totalSantriCount: null == totalSantriCount ? _self.totalSantriCount : totalSantriCount // ignore: cast_nullable_to_non_nullable
as int,attendancePercent: null == attendancePercent ? _self.attendancePercent : attendancePercent // ignore: cast_nullable_to_non_nullable
as double,setoranCount: null == setoranCount ? _self.setoranCount : setoranCount // ignore: cast_nullable_to_non_nullable
as int,setoranPercent: null == setoranPercent ? _self.setoranPercent : setoranPercent // ignore: cast_nullable_to_non_nullable
as double,latestSetoran: null == latestSetoran ? _self._latestSetoran : latestSetoran // ignore: cast_nullable_to_non_nullable
as List<LatestSetoranItem>,
  ));
}


}

/// @nodoc


class _Error implements DashboardSummaryState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of DashboardSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DashboardSummaryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DashboardSummaryStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DashboardSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
