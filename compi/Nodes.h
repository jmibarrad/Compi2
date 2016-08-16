#include <iostream>
#include <string.h>
#include <map>

using namespace std;


map<string,int> mapper;

class Expression{
	public: virtual int Evaluate() = 0;
};

class AddExpression : public Expression{
	public:
		Expression *e1, *e2;
		AddExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() + e2 -> Evaluate();
		}
};

class MultExpression : public Expression{
	public:
		Expression *e1, *e2;
		MultExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() * e2 -> Evaluate();
		}
};

class GreaterExpression : public Expression{
	public:
		Expression *e1, *e2;
		GreaterExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() > e2 -> Evaluate();
		}
};

class LesserExpression : public Expression{
	public:
		Expression *e1, *e2;
		LesserExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() < e2 -> Evaluate();
		}
};

class GreaterOrEqualExpression : public Expression{
	public:
		Expression *e1, *e2;
		GreaterOrEqualExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() >= e2 -> Evaluate();
		}
};

class LesserOrEqualExpression : public Expression{
	public:
		Expression *e1, *e2;
		LesserOrEqualExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() <= e2 -> Evaluate();
		}
};

class EqualityExpression : public Expression{
	public:
		Expression *e1, *e2;
		EqualityExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() == e2 -> Evaluate();
		}
};

class InequalityExpression : public Expression{
	public:
		Expression *e1, *e2;
		InequalityExpression(Expression *e1, Expression *e2){
			this->e1 = e1;
			this->e2 = e2;
		} 
		int Evaluate(){
			return e1 -> Evaluate() != e2 -> Evaluate();
		}
};

class NumExpression : public Expression{
	public:
		int value;

		NumExpression(int value){
			this->value = value;
		}

		int Evaluate(){
			return value;
		}
};

class IdExpression : public Expression{
	public:
		string Id;

		IdExpression(string Id){
			this->Id = Id;
		}

		int Evaluate(){
			//chekear en tabla
			return mapper[Id];
		}
};

////////////////////////////////////////

class Statement{
	public: virtual void Evaluate() = 0;

	Statement * nextStatement;
};

class PrintStatement : public Statement{
	public: 
		Expression *e1;

		PrintStatement(Expression *e1){
			this->e1 = e1;
		}

		void Evaluate(){
			cout << "printing ";
			cout << e1->Evaluate() << endl;

			if(nextStatement != NULL)
				nextStatement->Evaluate();
		}
};

class AssignStatement : public Statement{
	public:
		char *id;
		Expression *e1;

		AssignStatement(char * id, Expression * e1){
			this->id = id;
			this->e1 = e1;
		}

		void Evaluate(){
			//agregar a la tabla de simbolos
			string mystring(id);
			int eval = e1->Evaluate();

			mapper[mystring]=eval;

			cout << "debug " << mystring << " = " << eval << endl;

			if(nextStatement != NULL)
				nextStatement->Evaluate();
		}
};

class IfStatement : public Statement{
	public:
		Expression *e1;
		Statement *statement;
		Statement *statement2;

		IfStatement(Expression * e1, Statement * statement, Statement * statement2){
			this->e1 = e1;
			this->statement = statement;
			this->statement2 = statement2;
		}

		void Evaluate(){
			
			int eval = e1->Evaluate();
			cout << eval << " -- " << endl;
			if(e1->Evaluate()){
				statement->Evaluate();
			}else{
				if(statement2 != NULL)
					statement2->Evaluate();
			}

			if(nextStatement != NULL)
				nextStatement->Evaluate();
		}
};