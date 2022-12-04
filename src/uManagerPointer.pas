unit uManagerPointer;

interface

type
  TManagerPointer<T: class, constructor> = record
  strict private
    fValue: T;
    fInstance: IInterface;
    function GetValue: T;
  public
    class operator Implicit(Manager: TManagerPointer<T>): T;
    class operator Implicit(Value: T): TManagerPointer<T>;
    constructor Create(Value: T); reintroduce;

    property Value: T read GetValue;
  end;

  TManagerValue = class(TInterfacedObject)
  private
    fObject: TObject;
  public
    constructor Create(Instance: TObject); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TManagerPointer<T> }

constructor TManagerPointer<T>.Create(Value: T);
begin
  inherited;

  fValue:= Value;

  fInstance:= TManagerValue.Create(fValue);
end;

function TManagerPointer<T>.GetValue: T;
begin
  if not Assigned(fInstance) then
    Self:= TManagerPointer<T>.Create(T.Create);

  Result:= fValue;
end;

class operator TManagerPointer<T>.Implicit(Manager: TManagerPointer<T>): T;
begin
  Result:= Manager.Value;
end;

class operator TManagerPointer<T>.Implicit(Value: T): TManagerPointer<T>;
begin
  Result:= TManagerPointer<T>.Create(Value);
end;

{ TManagerValue }

constructor TManagerValue.Create(Instance: TObject);
begin
  inherited Create;

  fObject:= Instance;
end;

destructor TManagerValue.Destroy;
begin
  FreeAndNil(fObject);

  inherited Destroy;
end;

end.
